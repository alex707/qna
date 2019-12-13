class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Link, Award, Vote]
    can :update, [Question, Answer, Comment, Vote], user_id: user.id
    can :destroy, [Question, Answer, Comment, Link, Vote], user_id: user.id

    can :vote!, [Question, Answer] do |entity| !user.author?(entity) end
    can :favour, Answer, question: { user_id: user.id }
  end
end