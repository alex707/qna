require 'rails_helper'

shared_examples 'comment view' do
  given(:klass) { entity.class.to_s.downcase }

  describe 'Authenticated user' do
    background do
      sign_in(create(:user))
      visit visit_entity_path
    end

    scenario 'User can comment the entity', js: true do
      within ".new-#{klass}-#{entity.id}-comment" do
        fill_in 'Comment body', with: 'Some Text'

        click_on 'Add comment'
      end

      within "ul.#{klass}-#{entity.id}-comments" do
        expect(page).to have_content('Some Text')
      end
    end

    scenario 'User tries comment the entity with blank comment', js: true do
      within ".new-#{klass}-#{entity.id}-comment" do
        fill_in 'Comment body', with: ''

        click_on 'Add comment'
      end

      expect(page).to have_content("Body can't be blank")
    end
  end

  describe 'Not Authenticated user' do
    scenario 'User tries to comment the entity', js: true do
      visit visit_entity_path
      within ".#{klass}-#{entity.id}-votes" do
        expect(page).to_not have_link 'Comment'
      end
    end
  end
end
