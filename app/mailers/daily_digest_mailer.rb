# last day created questions mailer
class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: Date.yesterday.all_day)

    mail(
      to: user.email,
      subject: 'Digest',
      from: 'from@example.com'
    )
  end
end
