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
    has_voted = entity.voted?(current_user)
    vote = entity.votes.find_by(user: current_user)

    if button.in?(%w[like dislike])
      !has_voted || (button != vote.value)
    else
      has_voted && (button =~ Regexp.new(vote.value))&.zero?
    end
  end
end
