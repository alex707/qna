class DailyDigestMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.last_day_created
    return if @questions.empty?

    mail subject: 'Digiset'
    mail to: user.email
    mail from: 'from@example.com'
  end
end
