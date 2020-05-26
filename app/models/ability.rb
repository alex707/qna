class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    return guest_abilities unless user

    user.admin? ? admin_abilities : user_abilities
  end

  def guest_abilities
    can :read, :all
    can :search, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Award, Vote, Subscription]
    can %i[create destroy], Link do |link|
      user.author?(link.linkable)
    end
    can %i[update destroy], [Question, Answer, Comment, Vote], user_id: user.id
    can :vote!, [Question, Answer] do |entity|
      !user.author?(entity)
    end
    can :favour, Answer, question: { user_id: user.id }
    can :destroy, Subscription, user_id: user.id
  end
end
