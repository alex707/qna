class QuestionsChannel < ApplicationCable::Channel
  # def echo(data)
  #   transmit data
  # end

  def follow
    stream_from 'questions'
  end
end
