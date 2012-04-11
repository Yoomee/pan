class Ability
  
  include CanCan::Ability
  
  def initialize(user)
    if user.try(:admin?)
      can :manage, :all      
    elsif user
      can :manage, User, :id => user.id
      can :show, Page, :published => true
    else
      cannot [:create, :update, :destroy], :all
      can :show, Page, :published => true
      cannot [:mercury_update], Page
    end
  end
  
end
