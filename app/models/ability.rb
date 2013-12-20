class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, Feedback
    if user.roles.detect{|r|r.name == "Manager"}
      can :manage, Project
      can :manage, User
      can :manage, ReportCategory
      can :manage, Group
      can :manage, Team
      can :manage, Sticky
      can :manage, Report
      can :manage, ProjectUser
      can :manage, Checkpoint
      can :manage, CheckpointPeriod
    elsif user.roles.detect{|r|r.name == "HR"}
      can :manage, User
      can :manage, ReportCategory
      can :manage, Group
      can :manage, Team
      can :manage, Sticky
      can :index, Report
      can :manage, Payslip
      can :manage, CheckpointQuestion
      can :manage, Checkpoint
      can :manage, CheckpointPeriod
    elsif user.roles.detect{|r|r.name == "Leader"}
      can [:index, :show], Report do |report|
        user.team_id == report.user.team.id
      end
      can :manage, Report do |report|
        user.id == report.user_id
      end
      can [:index, :edit, :update, :get_all_user, :update_profile], User do |current|
        user.id == current.id
      end
      can [:show, :profile], User

      can [:index], User do |current|
        user.team_id == current.team.id
      end
      can [:index, :new, :create], Cost
      can [:edit, :update, :destroy, :show], Cost do |cost|
        user.id == cost.user_id
      end
      can :manage, Sticky
      can [:edit, :index, :update, :show], Checkpoint do |checkpoint|
        user.id == checkpoint.user_id
      end
      can :review, Checkpoint
      
    else
      can :manage, Sticky
      can [:index, :edit, :update, :get_all_user, :profile, :update_profile], User do |current|
        user.id == current.id
      end
      can [:show, :profile], User
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
      can [:edit, :index, :update, :show], Checkpoint do |checkpoint|
        user.id == checkpoint.user_id
      end
      
    end
  end
end
