class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :facilities
  has_one :privilege

  validates :first_name, :last_name, presence: true

  enum role: [:client, :superadmin].freeze
  enum status: [:inactive, :active].freeze

  scope :admin, -> {joins(:privilege).where("privileges.admin LIKE ? OR role = ?", "%R%", 1).distinct}

  accepts_nested_attributes_for :privilege

  def self.from_omniauth(auth)
    if where(email: auth.info.email || "#{auth.uid}@#{auth.provider}.com").present?
      where(email: auth.info.email || "#{auth.uid}@#{auth.provider}.com").first do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.first_name = auth.info.first_name rescue nil
        user.last_name = auth.info.last_name rescue nil
        user.email = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
        user.login = auth.info.email || "#{auth.uid}@#{auth.provider}.com"
        user.first_name ||= user.login
        user.last_name ||= user.login
        user.password = Devise.friendly_token[0, 20]
      end
    else
      nil
    end
  end

  def active_for_authentication?
    super and self.active?
  end

  def inactive_message
    "You are not allowed to log in!"
  end

  def abilities
    Ability.new(self).permissions
  end

  def admin?
    superadmin? || privilege.admin.include?("R")
  end

  def initialize(*args)
     privilege ||= Privilege.new
     super
  end
end
