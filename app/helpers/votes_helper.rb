module VotesHelper
  def vote_button(button, entity)
    value = button.in?(%w[like dislike]) ? button : 'none'
    klass = entity.class.to_s.downcase
    show = show_button?(button, entity)

    link_to button.capitalize,
            send("vote_#{klass}_path", entity, value: value, voteable: klass),
            class: "vote-btn #{button} #{'hidden' unless show}",
            data: { parent_id: entity.id, value: button, parent_class: klass, type: :json },
            method: :post, remote: true
  end

  private

  def show_button?(button_name, entity)
    vote = entity.votes.find_by(user: current_user)
    if button_name.in?(%w[like dislike])
      vote.nil? ? true : vote.value != button_name
    else
      vote.nil? ? false : (button_name =~ Regexp.new(vote.value))&.zero?
    end
  end
end
