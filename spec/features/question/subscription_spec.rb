require 'rails_helper'

feature 'User can manage subscription from question page', %{
  In order to subscribe or unsuscribe for created question answers
  As an authenticated user
  I'd like to be able to push button subscribe/unsuscribe
} do
  describe 'Authenticated user' do
    describe 'subscribe for question' do
      given(:user) { create(:user) }
      given(:question) { create(:question) }

      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'User can subscribe for question answers', js: true do
        within '.subscription' do
          click_on 'Subscribe'

          expect(page).to have_link('Unsubscribe')
          expect(page).to_not have_link('Subscribe')
        end

        within 'p.notice' do
          expect(page).to have_content('You are subscribed for answer questions', wait: 2)
        end
      end
    end

    describe 'unsubscribe for question' do
      given(:user) { create(:user) }
      given(:question) { create(:question) }

      background do
        sign_in(user)
        question.subscribe!(user)

        visit question_path(question)
      end

      scenario 'User can unsubscribe for question answers', js: true do
        within '.subscription' do
          click_on 'Unsubscribe'

          expect(page).to have_link('Subscribe')
          expect(page).to_not have_link('Unsubscribe')
        end

        within 'p.notice' do
          expect(page).to have_content('You are unsubscribed for answer questions', wait: 2)
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    background do
      visit question_path(question)
    end

    scenario 'tries subscribe for question' do
      within '.subscription' do
        expect(page).to_not have_link('Subscribe')
      end
    end

    scenario 'tries unsubscribe for question' do
      within '.subscription' do
        expect(page).to_not have_link('Unsubscribe')
      end
    end
  end
end
