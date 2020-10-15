class User < ApplicationRecord
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable

  has_many :project_users, dependent: :destroy
  has_many :projects, through: :project_users
  has_many :facilities
  has_one :privilege, dependent: :destroy
  belongs_to :organization, optional: true

  validates :first_name, :last_name, presence: true
  before_commit :set_color, on: :create

  enum role: [:client, :superadmin].freeze
  enum status: [:inactive, :active].freeze

  scope :admin, -> {joins(:privilege).where("privileges.admin LIKE ? OR role = ?", "%R%", 1).distinct}

  accepts_nested_attributes_for :privilege, reject_if: :all_blank

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

  def full_name
    "#{first_name} #{last_name}"
  end

  def as_json(options=nil)
    json = super(options)
    json.merge(
      full_name: full_name
    ).as_json
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

  def admin_read?
    superadmin? || privilege.admin.include?("R")
  end

  def admin_write?
    superadmin? || (admin_read? && privilege.admin.include?("W"))
  end

  def admin_delete?
    superadmin? || (admin_read? && privilege.admin.include?("D"))
  end

  def admin_privilege
    superadmin? ? "RWD" : privilege.admin
  end

  def download_links?
    admin_write? ? [:csv, :json] : false
  end

  def set_color
    self.color = "##{SecureRandom.hex(3)}"
  end

  def project_names
    projects.active.pluck :name
  end

end
