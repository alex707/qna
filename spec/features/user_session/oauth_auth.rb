require 'rails_helper'

feature 'User can authenticate via social network', %{
  In order to use site
  As an unauthenticated user
  I'd like to be able to sign in via social network
} do
  describe 'for GitHub' do
    scenario 'can sign in user with GitHub account' do
      visit new_user_session_url
      expect(page).to have_content('Sign in with GitHub')
      mock_auth_hash_github
      click_link 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated')
      expect(page).to have_content('Sign out')
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit new_user_session_url
      expect(page).to have_content('Sign in with GitHub')
      click_link 'Sign in with GitHub'
      expect(page).to have_content('Could not authenticate')
    end
  end

  describe 'for Vkontakte' do
    scenario 'can sign in user with Vkontakte account' do
      visit new_user_session_url
      expect(page).to have_content('Sign in with Vkontakte')
      mock_auth_hash_vkontakte
      click_link 'Sign in with Vkontakte'
      expect(page).to have_content('Successfully authenticated')
      expect(page).to have_content('Sign out')
    end

    scenario 'can handle authentication error' do
      OmniAuth.config.mock_auth[:vkontakte] = :invalid_credentials
      visit new_user_session_url
      expect(page).to have_content('Sign in with Vkontakte')
      click_link 'Sign in with Vkontakte'
      expect(page).to have_content('Could not authenticate')
    end
  end
end
