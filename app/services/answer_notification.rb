module Services
  # for sending notification to question author about new answer
  class AnswerNotification
    def send_notification(question)
      question.subscriptions.includes(:user).find_each do |subscription|
        AnswerNotificationMailer.notification(
          question, subscription.user
        ).deliver_later
      end
    end
  end
end
