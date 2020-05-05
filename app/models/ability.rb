# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    elsif user.subscriber?
      can :manage, :all
      unless user.privileges.include?('Tasks')
        cannot :manage, Task
      end
    end
  end
end
