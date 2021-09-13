# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.superadmin?
      can :manage, :all
    else
      can [:read], "Overview" if user.privilege.overview.include?('R')
      can [:create, :update], "Overview" if user.privilege.overview.include?('W')
      can [:destroy], "Overview" if user.privilege.overview.include?('D')
      can [:read], Task if user.privilege.tasks.include?('R')
      can [:create, :update], Task if user.privilege.tasks.include?('W')
      can [:destroy], Task if user.privilege.tasks.include?('D')
      can [:read], Note if user.privilege.notes.include?('R')
      can [:create, :update], Note if user.privilege.notes.include?('W')
      can [:destroy], Note if user.privilege.notes.include?('D')
      can [:read], Issue if user.privilege.issues.include?('R')
      can [:create, :update], Issue if user.privilege.issues.include?('W')
      can [:destroy], Issue if user.privilege.issues.include?('D')
      can [:read], "Admin" if user.privilege.admin.include?('R')
      can [:create, :update], "Admin" if user.privilege.admin.include?('W')
      can [:destroy], "Admin" if user.privilege.admin.include?('D')

      can [:read], Lesson do |lesson|
        user.privilege.lessons.include?('R')
      end
      can [:create, :update], Lesson if user.privilege.lessons.include?('W')
      can [:destroy], Lesson if user.privilege.lessons.include?('D')


    end
  end
end
