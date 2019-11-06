module VotesHelper
  def vote_button(button, entity)
    value = button.in?(%w[like dislike]) ? button : nil
    klass = entity.class.to_s.downcase
    show = show_button?(button, entity)

    link_to button.capitalize,
            send('vote_path', id: entity, value: value, voteable: klass),
            class: "vote-btn #{button} #{'hidden' unless show}",
            data: { parent_id: entity.id, value: button, parent_class: klass, type: :json },
            method: :post, remote: true
  end

  private

  def show_button?(button, entity)
    vote = entity.votes.find_by(user: current_user)
    if button.in?(%w[like dislike])
      !entity.voted?(current_user) || (button != vote.value)
    else
      entity.voted?(current_user) && (button =~ Regexp.new(vote.value))&.zero?
    end
  end
end
