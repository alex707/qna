require 'rails_helper'

feature 'User can vote for liked question', %{
  In order to vote for liked question
  As an authenticated user
  I'd like to be able to like
} do
  given(:owner) { create(:user) }
  given(:stranger1) { create(:user) }
  given!(:stranger2) { create(:user) }
  given(:question) { create(:question, user: owner) }

  describe 'Authenticated user' do
    describe 'as not owner' do
      background do
        sign_in(stranger1)
        visit question_path(question)
      end

      scenario 'User can like the question', js: true do
        within '.question' do
          within ".question-#{question.id}-votes" do
            within ".question-#{question.id}-likes" do
              expect(page).to have_content('0')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.like').click

            within ".question-#{question.id}-likes" do
              expect(page).to have_content('1')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end
          end
        end
      end

      scenario 'User can take his like back', js: true do
        within '.question' do
          within ".question-#{question.id}-votes" do
            find('a.vote-btn.like').click

            within ".question-#{question.id}-likes" do
              expect(page).to have_content('1')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.liked').click

            within ".question-#{question.id}-likes" do
              expect(page).to have_content('0')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end
          end
        end
      end

      scenario 'User can vote for another', js: true do
        within '.question' do
          within ".question-#{question.id}-votes" do
            find('a.vote-btn.like').click

            within ".question-#{question.id}-likes" do
              expect(page).to have_content('1')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.dislike').click

            within ".question-#{question.id}-likes" do
              expect(page).to have_content('0')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('1')
            end
          end
        end
      end

      scenario 'User can vote with another user', js: true do
        question.vote!('like', stranger2)

        visit question_path(question)
        within '.question' do
          within ".question-#{question.id}-votes" do
            within ".question-#{question.id}-likes" do
              expect(page).to have_content('1')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.like').click

            within ".question-#{question.id}-likes" do
              expect(page).to have_content('2')
            end
            within ".question-#{question.id}-dislikes" do
              expect(page).to have_content('0')
            end
          end
        end
      end
    end

    describe 'as an owner' do
      background do
        sign_in(owner)
        visit question_path(question)
      end

      scenario 'User can like the question', js: true do
        within '.question' do
          within ".question-#{question.id}-votes" do
            %w[like liked dislike disliked].each do |name|
              expect(page).to_not have_link name
            end
          end
        end
      end
    end
  end

  describe 'Not Authenticated user' do
    scenario 'User tries to like the question', js: true do
      visit question_path(question)
      within '.question' do
        within ".question-#{question.id}-votes" do
          %w[like liked dislike disliked].each do |name|
            expect(page).to_not have_link name
          end
        end
      end
    end
  end
end
