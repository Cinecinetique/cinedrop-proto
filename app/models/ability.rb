class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # guest user (not logged in)

    if user.has_role? :member or user.has_role? :crew or user.has_role? :admin or user.has_role? :subscriber
        can :read, Plan
        can :read, Project do |project|
            project.workers.find_by_user_id(user.id) != nil if project
        end
    end

    if user.has_role? :subscriber
        can :create, Project
        can :update, Project
        can :destroy, Project do |project|
            project.try(:created_by) == user.id
        end
    end

    if user.has_role? :crew or user.has_role? :admin or user.has_role? :subscriber
        can :read, Project
    end
    
  end
end
