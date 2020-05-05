class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :facilities

  serialize :privileges
  validates :first_name, :last_name, presence: true

  enum role: [:subscriber, :admin].freeze
  enum status: [:inactive, :active].freeze

  PRIVILIGES = ['Tasks']

  def self.from_omniauth(auth)
    if where(email: auth.info.email || "#{auth.uid}@#{auth.provider}.com").present?
      return where(email: auth.info.email || "#{auth.uid}@#{auth.provider}.com").first
    end
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
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
  end

  def active_for_authentication?
    super and self.active?
  end

  def privileges
    Array.wrap(super)
  end

  def inactive_message
    "You are not allowed to log in!"
  end

  def abilities
    Ability.new(self).permissions
  end
end
