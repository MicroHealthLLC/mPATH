class RiskUser < ApplicationRecord
  belongs_to :user
  belongs_to :risk

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

   # Risk Approver https://github.com/MicroHealthLLC/mGis/issues/1734

  def approver?
    user_type == "approver"
  end

end
