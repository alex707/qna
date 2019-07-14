require 'rails_helper'

feature 'User can sign up', %q{
  In order to working with resource
  As an unregistrated user
  I'd like to be able to sign_up
} do
  scenario 'Unregistred user tries sign up' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@test.tt'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end
end
