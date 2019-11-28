require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :user }
  it { should belong_to :commentable }

  it { should validate_presence_of(:body) }

  context 'checking order' do
    let(:bodies_arr) { %w(comment_2 comment_22 comment_222) }
    let(:question) { create(:question) }

    before do
      question.comments.create!(body: bodies_arr.first, user: create(:user))
      question.comments.create!(body: bodies_arr.second, user: create(:user))
      question.comments.create!(body: bodies_arr.third, user: create(:user))
    end

    it 'default order by ascending created_at' do
      expect(question.comments.pluck(:body)).to eq bodies_arr
    end
  end

  context 'checking returns question of commented entity' do
    let(:question) { create(:question, :with_comments) }
    let(:answer) { create(:answer, :with_comments, question: question) }
    let(:comment_of_question) { question.comments.second }
    let(:comment_of_answer) { answer.comments.first }

    it 'return question of commented question' do
      expect(comment_of_question.question).to eq question
    end

    it 'return question of commented answer' do
      expect(answer.question).to eq question

      expect(comment_of_answer.question).to eq question
    end
  end
end
