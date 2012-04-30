# Don't delete comments, they are used in gems for adding abilities
class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    
    # open ability
    can :show, Page, :published => true
    can :index, Page
    
    if user.try(:admin?)
      can :manage, :all
      # admin ability
    elsif user
      # user ability
      can [:read, :create], Post
      can [:update, :destroy], Post, :user_id => user.id
      can :manage, User, :id => user.id
      can :search, :all
    end
  end
  
end
