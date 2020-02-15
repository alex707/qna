require 'rails_helper'

RSpec.describe AnswerNotificationMailer, type: :mailer do
  let!(:answer) { create(:answer) }

  describe 'answer notification' do
    let(:mail) { AnswerNotificationMailer.notification(answer.question) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notification')
      expect(mail.to).to eq([answer.question.user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(answer.question.title)
    end
  end
end
