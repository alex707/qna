module QuestionsHelper
  def form_class(question)
    question.new_record? ? 'new-question' : 'hidden'
  end
end
