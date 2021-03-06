require 'rails_helper'

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'last day questions digest' do
    let(:user) { create(:user) }

    context 'when questions has been created at last day' do
      let!(:questions) { create_list(:question, 2, created_at: 1.day.ago) }
      let!(:day_before_yesterday_question) {
        create(:question, created_at: 2.days.ago, title: 'ZZ')
      }
      let(:mail) { DailyDigestMailer.digest(user) }

      it 'renders the headers' do
        expect(mail.subject).to eq('Digest')
        expect(mail.to).to eq([user.email])
        expect(mail.from).to eq(['from@example.com'])
      end

      it 'contain yesterday questions' do
        expect(mail.body.encoded).to match(questions.first.title)
      end

      it 'not contain old question' do
        expect(
          mail.body.encoded
        ).to_not match(day_before_yesterday_question.title)
      end
    end

    context 'when questions has not been created at last day' do
      let(:mail) { DailyDigestMailer.digest(user) }

      it 'mailer returns nil' do
        expect(mail).to_not be_a(Mail::Message)
      end
    end
  end
end
