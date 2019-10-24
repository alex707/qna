module QuestionsHelper
  def form_class(question)
    question.new_record? ? 'new-question' : 'hidden'
  end

  def vote_button(button, entity)
    vote = entity.votes.find_by(user: current_user)&.value || 'none'
    hidden = button.in?(%w[liked disliked]) ? button.in?(%w[like dislike]) : button == vote
    value = button.in?(%w[like dislike]) ? button : 'none'

    link_to button.capitalize,
            vote_question_path(entity, value: value, voteable: 'question'),
            class: "vote-question #{button} #{'hidden' if hidden}",
            data: { parent_id: entity.id, value: button, type: :json },
            method: :post, remote: true
  end
end
