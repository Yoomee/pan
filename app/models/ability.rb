# Don't delete comments, they are used in gems for adding abilities
class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    # open ability
    can :create, Enquiry
    can :show, Page, :published => true
    can :index, Page
    
    if user.try(:admin?)
      can :manage, :all
      # admin ability
    else
      if user.try(:performer)
        can [:read, :create], Post
        can :update, Performer, :id => user.performer_id
      end
      if user
        # user ability
        can [:update, :destroy], Post, :user_id => user.id
        can :manage, User, :id => user.id
        can :search, :all
        can :read, Performer
      end
    end
  end
  
end
