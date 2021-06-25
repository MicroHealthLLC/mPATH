class LessonUser < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  # Different User types https://github.com/MicroHealthLLC/mGis/issues/888
  # Responsible
  # Accountable
  # Consulted
  # Informed

  def accountable?
    user_type == "accountable"
  end

  def responsible?
    user_type == "responsible"
  end

  def consulted?
    user_type == "consulted"
  end

  def informed?
    user_type == "informed"
  end
end
