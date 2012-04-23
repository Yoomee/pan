# Don't delete comments, they are used in gems for adding abilities
class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    # open ability
    can :show, Page, :published => true
    
    if user.try(:admin?)
      can :manage, :all      
      # admin ability
    elsif user
      # user ability
      can :read, Post
      can :create, Post, :resource => false
      can [:update, :destroy], Post, :user_id => user.id
      can :manage, User, :id => user.id
    end
  end
  
end
