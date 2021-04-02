class FavoriteFilter < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :query_filters, dependent: :destroy

  def to_json(options = {})
    {
      id: self.id,
      name: self.name,
      query_filters: query_filters.map(&:to_json),
      project_id: self.project_id,
      user_id: self.user_id
    }
  end

end
