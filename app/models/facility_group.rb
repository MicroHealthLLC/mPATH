class FacilityGroup < SortableRecord
  # default_scope {order(FacilityGroup.order_humanize)}
  has_many :facilities
  has_many :facility_projects, through: :facilities
  has_many :project_contracts
  has_many :project_facility_groups
  has_many :projects, through: :project_facility_groups
  has_many :contracts

  validates :name, presence: true #, uniqueness: true

  enum status: [:inactive, :active].freeze
  before_save :set_status
  
  def apply_unassigned_to_resource(project)
    
    unassigned = project.default_facility_group
    if unassigned
      facilities.update_all(facility_group_id: unassigned.id)
      project_contracts.update_all(facility_group_id: unassigned.id)
    else
      false
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
    (is_default || is_portoflio.present?) ? (raise ActiveRecord::StatementInvalid.new("Can't destroy") ) : super
  end
end
