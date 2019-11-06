require 'rails_helper'

shared_examples 'vote view' do
  given(:owner) { create(:user) }
  given(:stranger1) { create(:user) }
  given!(:stranger2) { create(:user) }
  given(:klass) { entity.class.to_s.downcase }

  describe 'Authenticated user' do
    describe 'as not owner' do
      background do
        sign_in(stranger1)
        visit visit_entity_path
      end

      scenario 'User can like the entity', js: true do
        within ".#{klass}-#{entity.id}-votes" do
          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('0')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end

          find('a.vote-btn.like').click

          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('1')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end
        end
      end

      scenario "User can't like the entity again", js: true do
        within ".#{klass}-#{entity.id}-votes" do
          find('a.vote-btn.like').click

          expect(page).not_to have_content(/^Like$/)
        end
      end

      scenario 'User can take his like back', js: true do
        within ".#{klass}-#{entity.id}-votes" do
          find('a.vote-btn.like').click

          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('1')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end

          find('a.vote-btn.liked').click

          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('0')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end
        end
      end

      scenario 'User can vote for another', js: true do
        within ".#{klass}-#{entity.id}-votes" do
          find('a.vote-btn.like').click

          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('1')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end

          find('a.vote-btn.dislike').click

          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('0')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('1')
          end
        end
      end

      scenario 'User can vote with another user', js: true do
        entity.vote!('like', stranger2)

        visit visit_entity_path
        within ".#{klass}-#{entity.id}-votes" do
          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('1')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end

          find('a.vote-btn.like').click

          within ".#{klass}-#{entity.id}-likes" do
            expect(page).to have_content('2')
          end
          within ".#{klass}-#{entity.id}-dislikes" do
            expect(page).to have_content('0')
          end
        end
      end
    end

    describe 'as an owner' do
      background do
        sign_in(entity.user)
        visit visit_entity_path
      end

      scenario 'User can like the entity', js: true do
        within ".#{klass}-#{entity.id}-votes" do
          %w[like liked dislike disliked].each do |name|
            expect(page).to_not have_link name
          end
        end
      end
    end
  end

  describe 'Not Authenticated user' do
    scenario 'User tries to like the entity', js: true do
      visit visit_entity_path
      within ".#{klass}-#{entity.id}-votes" do
        %w[like liked dislike disliked].each do |name|
          expect(page).to_not have_link name
        end
      end
    end
  end
end
