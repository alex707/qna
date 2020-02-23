require 'rails_helper'

RSpec.describe Services::AnswerNotification do
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, question: question) }

  it 'sends notification about created answer for question author' do
    answer = question.answers.build(user: create(:user), body: 'abc')
    answer.save

    expect(AnswerNotificationMailer).to receive(:notification).with(
      answer.question, subscription.user
    ).and_call_original

    subject.send_notification(answer.question)
  end
end
