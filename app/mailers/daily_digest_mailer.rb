# last day created questions mailer
class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.last_day_created
    return if @questions.empty?

    mail(
      to: user.email,
      subject: 'Digest',
      from: 'from@example.com'
    )
  end
end
