require 'rails_helper'

feature 'User can view all his awards', %{
  In order to watch my awads
  As an favourite answer's author
  I'd like to be able to watch my awards
} do
  given(:user) { create(:user) }
  given(:new_user) { create(:user) }
  given(:question1) { create(:question_with_answers, user: user) }
  given(:question2) { create(:question_with_answers, user: user) }
  given(:answer1) { create(:answer, question: question1, user: new_user) }
  given(:answer2) { create(:answer, question: question2, user: new_user) }

  before do
    answer1.favour
    answer2.favour
  end

  describe 'Authenticated user' do
    before { sign_in(new_user) }

    scenario "Favourite answer's author watch his awards" do
      visit awards_path

      [question1, question2].each do |q|
        expect(page).to have_content(q.title)
        expect(page).to have_content(q.award.name)
        expect(page).to have_css("img[src*='#{url_for(q.award.image)}']")
      end
    end
  end
end
