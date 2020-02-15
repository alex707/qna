# mailer for sending notification to question author about new answer
class AnswerNotificationMailer < ApplicationMailer
  def notification(question)
    @question = question

    mail to: question.user.email
    mail subject: 'Notification'
    mail from: 'from@example.com'
  end
end
