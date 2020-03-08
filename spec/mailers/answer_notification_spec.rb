require 'rails_helper'

RSpec.describe AnswerNotificationMailer, type: :mailer do
  let!(:answer) { create(:answer) }
  let!(:subscription) { create(:subscription, question: answer.question) }

  describe 'answer notification' do
    let(:mail) do
      AnswerNotificationMailer.notification(
        subscription.question, subscription.user
      )
    end

    it 'renders the headers' do
      expect(mail.subject).to eq('Notification')
      expect(mail.to).to eq([subscription.user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.question.title)
    end
  end
end
