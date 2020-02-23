# mailer for sending notification to question author about new answer
class AnswerNotificationMailer < ApplicationMailer
  def notification(question, user)
    @question = question

    mail to: user.email
    mail subject: 'Notification'
    mail from: 'from@example.com'
  end
end
