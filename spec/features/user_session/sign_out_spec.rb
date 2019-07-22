require 'rails_helper'

feature 'User can sign out', %q{
  In order to finish work with resource
  As an Authenticated user
  I'd like to be able to sign out
} do
  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'Authenticated user tries sign out' do
    visit root_path

    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully'
  end
end
