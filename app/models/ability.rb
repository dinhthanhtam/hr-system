class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.roles.detect{|r|r.name == "Manager"}
      can :manage, User
      can :manage, ReportCategory
      can :manage, Group
      can :manage, Team
      can :manage, Sticky
      can :manage, Report
    elsif user.roles.detect{|r|r.name == "HR"}
      can :manage, User
      can :manage, ReportCategory
      can :manage, Group
      can :manage, Team
      can :manage, Sticky
      can :manage, Report
    elsif user.roles.detect{|r|r.name == "Leader"}
      can [:index, :show], Report do |report|
        user.team_id == report.user.team.id
      end
      can :manage, Report do |report|
        user.id == report.user_id
      end
      can [:index, :show, :edit, :get_all_user], User do |current|
        user.id == current.id
      end

      can [:index], User do |current|
        user.team_id == current.team.id
      end

      can :manage, Sticky
    else
      can :manage, Sticky
      can [:index, :show, :edit, :get_all_user], User do |current|
        user.id == current.id
      end
      can :manage, Report do |report|
        user.id == report.user_id
      end
    end
  end
end
