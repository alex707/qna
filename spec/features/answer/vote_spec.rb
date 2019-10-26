require 'rails_helper'

feature 'User can vote for liked answer', %{
  In order to vote for liked answer
  As an authenticated user
  I'd like to be able to like
} do
  given(:owner) { create(:user) }
  given(:stranger1) { create(:user) }
  given!(:stranger2) { create(:user) }
  given(:question) { create(:question_with_answers, user: owner) }
  given(:answer) { question.answers[2] }

  describe 'Authenticated user' do
    describe 'as not owner' do
      background do
        sign_in(stranger1)
        visit question_path(question)
      end

      scenario 'User can like the answer and other like-counters not changed',
               js: true do
        within '.answers' do
          within ".answer-#{answer.id}-votes" do
            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('0')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.like').click

            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('1')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('0')
            end
          end

          [question.answers[0], question.answers[1]].each do |elem|
            within ".answer-#{elem.id}-votes" do
              %w[likes dislikes likes dislikes].each do |name|
                within(".answer-#{elem.id}-#{name}") do
                  expect(page).to have_content('0')
                end
              end
            end
          end
        end
      end

      scenario 'User can take his like back', js: true do
        within '.answers' do
          within ".answer-#{answer.id}-votes" do
            find('a.vote-btn.like').click

            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('1')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.liked').click

            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('0')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('0')
            end
          end
        end
      end

      scenario 'User can vote for another', js: true do
        within '.answers' do
          within ".answer-#{answer.id}-votes" do
            find('a.vote-btn.like').click

            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('1')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.dislike').click

            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('0')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('1')
            end
          end
        end
      end

      scenario 'User can vote with another user', js: true do
        answer.vote!('like', stranger2)

        visit question_path(question)
        within '.answers' do
          within ".answer-#{answer.id}-votes" do
            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('1')
            end
            within(".answer-#{answer.id}-dislikes") do
              expect(page).to have_content('0')
            end

            find('a.vote-btn.like').click

            within(".answer-#{answer.id}-likes") do
              expect(page).to have_content('2')
            end
            within(".answer-#{answer.id}-dislikes") do
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
        within '.answers' do
          within ".answer-#{answer.id}-votes" do
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
      within '.answers' do
        within ".answer-#{answer.id}-votes" do
          %w[like liked dislike disliked].each do |name|
            expect(page).to_not have_link name
          end
        end
      end
    end
  end
end
