# mailer for sending notification to question author about new answer
class AnswerNotificationMailer < ApplicationMailer
  def notification(question, user)
    @question = question

    mail(
      to: user.email,
      subject: 'Notification',
      from: 'from@example.com'
    )
  end
end
