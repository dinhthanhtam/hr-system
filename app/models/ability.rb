class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.roles.detect{|r|r.name == "Manager"}
      can :manage, Project
      can :manage, User
      can :manage, ReportCategory
      can :manage, Group
      can :manage, Team
      can :manage, Sticky
      can :manage, Report
      can :manage, ProjectUser
    elsif user.roles.detect{|r|r.name == "HR"}
      can :manage, User
      can :manage, ReportCategory
      can :manage, Group
      can :manage, Team
      can :manage, Sticky
      can :index, Report
      can :manage, Payslip
    elsif user.roles.detect{|r|r.name == "Leader"}
      can [:index, :show], Report do |report|
        user.team_id == report.user.team.id
      end
      can :manage, Report do |report|
        user.id == report.user_id
      end
      can [:index, :edit, :update, :get_all_user], User do |current|
        user.id == current.id
      end
      can :show, User

      can [:index], User do |current|
        user.team_id == current.team.id
      end
      can [:index, :new, :create], Cost
      can [:edit, :update, :destroy, :show], Cost do |cost|
        user.id == cost.user_id
      end
      can :manage, Sticky
    else
      can :manage, Sticky
      can [:index, :edit, :update, :get_all_user], User do |current|
        user.id == current.id
      end
      can :show, User
      can :manage, Report do |report|
        user.id == report.user_id
      end
      cannot :summary, Report
      can [:index, :new, :create], Cost
      can [:edit, :update, :destroy, :show], Cost do |cost|
        user.id == cost.user_id
      end
      can :show, Project do |project|
        user.projects.include? project
      end
    end
  end
end
