class FavoriteFilter < ApplicationRecord
  belongs_to :project
  belongs_to :user
  has_many :query_filters, dependent: :destroy

  def to_json(options = {})
    {
      id: self.id,
      filter_key: self.filter_key,
      name: self.name,
      filter_value: self.filter_value.present? ? JSON.parse(self.filter_value) : nil,
      # filter_value: self.filter_value,
      project_id: self.project_id,
      user_id: self.user_id
    }
  end

end
