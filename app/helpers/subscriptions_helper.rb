module SubscriptionsHelper
  def subscribe_button
    link_to 'Subscribe',
            subscriptions_path(question_id: @question),
            class: ['subscription-button',
                    'subscribe',
                    "#{'hidden' if current_user.subscribed?(@question)}"],
            method: :post, remote: true
  end

  def unsubscribe_button
    subscription = current_user.subscriptions.find_by(question: @question)

    link_to 'Unsubscribe',
            "#{subscription_path(subscription) if current_user.subscribed?(@question)}",
            class: ['subscription-button',
                    'unsubscribe',
                    "#{'hidden' unless current_user.subscribed?(@question)}"],
            method: :delete, remote: true
  end
end
