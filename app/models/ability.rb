# Don't delete comments, they are used in gems for adding abilities
class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    alias_action :index, :show, :directory, :to => :read
    
    # open ability
    can :create, Enquiry
    can :show, Page, :published => true
    can :index, Page
    can :create, User, :promoter_id => nil
    
    if user.try(:admin?)
      can :manage, :all
      # admin ability
    elsif user
      # user ability
      can [:create, :show], Post
      can [:update, :destroy], Post, :user_id => user.id
      can [:show, :update], User, :id => user.id
      can :search, :all
      can :read, Performer
      can :read, Promoter        
      can :read, Tour
      
      # performer ability
      if user.try(:performer_id)
        can :update, Performer, :id => user.performer_id
        can [:create, :update], Tour, :performer_id => user.performer_id
      end
      
      # promoter admin ability
      if user.promoter_admin?
        can [:create, :update], Promoter, :id => user.promoter_id
        can :read, Post        
        can :read, User        
        can :read, Venue
        can :manage, User, :promoter_id => user.promoter_id
        can :manage, Venue, :promoter_id => user.promoter_id
      end
    end
  end
  
end
