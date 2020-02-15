module Services
  # for sending notification to question author about new answer
  class AnswerNotification
    def send_notification(question)
      AnswerNotificationMailer.notification(question).deliver_later
    end
  end
end
