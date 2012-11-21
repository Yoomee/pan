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
    can :modal, Post
    
    if user.try(:admin?)
      can :manage, :all
      # admin ability
    elsif user
      # user ability
      can [:create], Comment
      can [:create, :show, :file], Post
      can [:update, :destroy], Post, :user_id => user.id
      can [:show, :update, :edit], User, :id => user.id
      can :search, :all
      can [:read, :rating], Performer
      can :read, Tour
      
      # performer ability
      if user.try(:performer_id)
        can :update, Performer, :id => user.performer_id
        can [:create, :update], Tour, :performer_id => user.performer_id
      end
      
      # promoter ability      
      if user.promoter
        can :read, :show
        can :read, :diary
        can :read, Post  
        can :read, User
        can :read, Venue   
        can [:read, :region], Promoter
        can [:create, :read], Review
        can :update, Review, :user_id => user.id
      end
      
      # promoter admin ability
      if user.promoter_admin?
        can [:create, :update], Promoter, :id => user.promoter_id
        # TODO: Make this ability work instead of 'can :update, Tour'
        # can [:create, :update], TourDate, :venue => {:id => user.venue_ids}
        can :update, Tour
        can [:update], Promoter, :id => user.promoter_id    
        can :read, User        
        can :read, Venue
        can :create, User, :promoter_id => user.promoter_id
        can :manage, Venue, :promoter_id => user.promoter_id
      end
    end
  end
  
end
