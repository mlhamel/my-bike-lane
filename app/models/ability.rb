class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    if user.admin?
      # Globally allow admins to do everything
      can :manage, :all
    else
      # Globally allow all to see
      can :read, :all
      can [:create, :heatmap], Violation
      can [:create], Photo
      can [:create, :update, :autocomplete], Violator
      can [:create, :update], Organization
      cannot :manage, Announcement
      cannot [:manage, :index], Subscription
      can :hide, Announcement
      can [:show, :robots, :public_show], Page
      cannot :index, Page
      can :public_index, BlogPost
      cannot :index, BlogPost
    end

    # Don't let a guest user behave like a regular user
    unless user.id == nil
      # Users can manage their own violations
      can [:update, :destroy], Violation, :user_id => user.id
      can [:update, :destroy], Photo, :user_id => user.id
      can [:update, :destroy], Subscription, :user_id => user.id

    # You can only flag if you're a user
      can [:flag, :up_vote, :down_vote], Violation
    end

    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
