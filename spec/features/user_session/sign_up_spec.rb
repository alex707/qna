require 'rails_helper'

feature 'User can sign up', %q{
  In order to working with resource
  As an unregistrated user
  I'd like to be able to sign_up
} do
  background { visit new_user_registration_path }

  scenario 'Unregistred user tries sign up with correct fields' do
    fill_in 'Email', with: 'test@test.tt'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end

  describe 'Unregistred user tries sign up' do
    scenario 'with uncorrect password confirmation field' do
      fill_in 'Email', with: 'test@test.tt'
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '123'

      click_on 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'with uncorrect all fields' do
      click_on 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end
  end
end
