class RelatedIssue < ApplicationRecord
  belongs_to :relatable, polymorphic: true
  belongs_to :sub_issue, class_name: "Issue", foreign_key: 'issue_id'
end
