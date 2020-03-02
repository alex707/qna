require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let!(:users) { create_list(:user, 2) }

  describe 'when questions there are' do
    let!(:questions) { create_list(:question, 2, created_at: 1.day.ago) }

    it 'sends daily digest for all users' do
      User.find_each do |user|
        expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
      end

      subject.send_digest
    end
  end

  describe 'when question are absent' do
    it 'not sends daily digest for all users' do
      User.find_each do |user|
        expect(DailyDigestMailer).not_to receive(:digest).with(user).and_call_original
      end

      subject.send_digest
    end
  end
end
