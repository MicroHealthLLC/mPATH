class FacilityGroup < SortableRecord
  # default_scope {order(FacilityGroup.order_humanize)}
  has_many :facilities
  has_many :facility_projects
  has_many :project_contracts
  has_many :project_facility_groups
  has_many :projects, through: :project_facility_groups
  has_many :contracts

  validates :name, presence: true #, uniqueness: true

  enum status: [:inactive, :active].freeze
  before_save :set_status
  after_destroy :apply_unassigned_to_resource

  def apply_unassigned_to_resource
    
    facility_projects_group = self.facility_projects.includes(:project).group_by{|fp| fp.project }
    project_contract_group = self.project_contracts.includes(:project).group_by{|fp| fp.project }

    facility_projects_group.each do |project, facility_projects|
      unassigned = project.default_facility_group
      facility_projects.each do |fp|
        fp.update(facility_group_id: unassigned.id)
      end
    end
    
    project_contract_group.each do |project, project_contracts|
      unassigned = project.default_facility_group
      project_contracts.each do |pc|
        pc.update(facility_group_id: unassigned.id)
      end
    end
  end

  def set_status
    if !status
      status = :active
    end
  end

  # def as_json(options=nil)
  #   json = super(options)
  #   fp = self.facility_projects
  #   json.merge(
  #     facilities: fp.as_json,
  #     project_ids: fp.pluck(:project_id).uniq
  #   ).as_json
  # end

  def update_progress
    t = self.facility_projects
    p = 0
    if t.any?
      p = (t.map(&:progress).sum / t.size).round(0)
    end
    self.update(progress: p)
  end

  # def progress
  #   self.facility_projects.map(&:progress).sum / self.facility_projects.count rescue 0
  # end

  def destroy
    if project_facility_groups.where(is_default: true).exists? || is_portfolio
      (raise ActiveRecord::StatementInvalid.new("Can't destroy because Groups is either default or portoflio group.") )
    else
      super
    end
  end
end
