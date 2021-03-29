# Types of filters
# 1) Project Groups - Multiple
# 2) Project Statuses - Multiple
# 3) Project Names  - Multiple
# 4) Project Completion Date Range - Multiple
# 5) Project % Progress Range - Multiple
# 6) Map Boundary Filter - Multiple
# 7) Task Stages - Multiple
# 8) Issue Types - Multiple
# 9) Issue Stages - Multiple
# 10) Issue Severities - Multiple
# 11) Risk Stages - Multiple
# 12) Risk Approaches - Multiple
# 13) Risk Priority Levels - Multiple
# 14) Categories - Multiple
# 15) Action Users  - Multiple
# 16) Flags  - Multiple
# 17) Action % Progress Range  - Multiple
# 18) Action Due Date Range  - Single
# 19) Updates Date Range  - Single

class QueryFilter < ApplicationRecord
  belongs_to :project
  belongs_to :user
  serialize :filter_value

  def to_json(options = {})
    {
      id: self.id,
      filter_key: self.filter_key,
      filter_value: self.filter_value.present? ? JSON.parse(self.filter_value) : nil,
      # filter_value: self.filter_value,
      project_id: self.project_id,
      user_id: self.user_id
    }
  end

end
