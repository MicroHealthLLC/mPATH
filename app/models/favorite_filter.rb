class FavoriteFilter < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :query_filters, dependent: :destroy
  validates_uniqueness_of :name, scope: :project
  validates_presence_of :name

  def to_json(options = {})
    {
      id: self.id,
      name: self.name,
      query_filters: query_filters.map(&:to_json),
      project_id: self.project_id,
      user_id: self.user_id,
      shared: self.shared,
      private: self.private
    }
  end

  def can_update?(user)
    self.user_id == user.id || user.privilege.admin.include?("W") || user.privilege.admin.include?("D")
  end

end
