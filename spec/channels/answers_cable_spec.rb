require 'rails_helper'

feature 'User can see created answer of another user', %{
  In order to provide sending of created answer
  As an a user
  I'd like to be able to broadcast of the answer to other users
}, :js do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  fcontext 'Multiply sessions' do
    context 'Only answer' do
      scenario "Answer appears on another user's question page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Your answer', with: 'Test answr'

          click_on 'Write'

          expect(page).to have_content 'Test answr'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test answr'
        end
      end
    end

    context 'Answer with links' do
      given(:gist_url) { 'https://gist.github.com/alex707/71d5c90e5cf72dc9765a2eebc2bfb416' }
      given(:url_ya) { 'https://ya.ru' }

      before do
        stub_request(:get, /api.github.com/).to_return(
          status: 200,
          body: File.new("#{Rails.root}/spec/support/fixtures/github_gist_2.json")
        )

        stub_request(:get, /ya.ru/).to_return(
          status: 200, body: '<html>some html<html>'
        )
      end

      scenario "Answer appears on another user's question page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          fill_in 'Your answer', with: 'Test answr'

          within 'form.new-answer' do
            fill_in 'Link name', with: 'My gist'
            fill_in 'Url', with: gist_url

            click_on 'Add link for answer'

            all '.nested-fields', count: 2

            within all('.nested-fields').last do
              fill_in 'Link name', with: 'My url ya'
              fill_in 'Url', with: url_ya
            end

            click_on 'Write'
          end

          using_wait_time 5 do
            within '.answers' do
              expect(page).to have_content('get-запрос на главную')
              expect(page).to have_link 'My url ya', href: url_ya
            end
          end
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test answr'

          using_wait_time 5 do
            within '.answers' do
              expect(page).to have_content('get-запрос на главную')
              expect(page).to have_link 'My url ya', href: url_ya
            end
          end
        end
      end
    end

    context 'Answer with attached files' do
      scenario "Answer appears on another user's question page" do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end

        Capybara.using_session('user') do
          within 'div.new-answer' do
            fill_in 'Your answer', with: 'Test answr'

            attach_file 'File', [
              "#{Rails.root}/spec/models/answer_spec.rb",
              "#{Rails.root}/spec/models/question_spec.rb"
            ]

            click_on 'Write'
          end

          within '.answers' do
            expect(page).to have_link 'answer_spec.rb'
            expect(page).to have_link 'question_spec.rb'
          end
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Test answr'

          within '.answers' do
            expect(page).to have_link 'answer_spec.rb'
            expect(page).to have_link 'question_spec.rb'
          end
        end
      end
    end
  end
end
