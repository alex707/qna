require 'rails_helper'

RSpec.describe Services::AnswerNotification do
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, question: question) }
  let(:answer) { question.answers.create(user: create(:user), body: 'abc') }
  let(:not_subscribed_user) { create(:user) }

  it 'sends notification about created answer for question author' do
    expect(AnswerNotificationMailer).to receive(:notification).with(
      answer.question, subscription.user
    ).and_call_original

    subject.send_notification(answer.question)
  end

  it 'not sends notification about created answer for not subscripted user' do
    expect(AnswerNotificationMailer).to_not receive(:notification).with(
      answer.question, not_subscribed_user
    )

    subject.send_notification(answer.question)
  end
end
