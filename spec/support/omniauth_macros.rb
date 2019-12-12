module OmniauthMacros
  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: 'github-test-uid-1',
      info: {
        name: 'github user',
        email: 'user-github@example.com',
        username: 'user_github'
      },
      credentials: {
        token: 'github_mock_token',
        secret: 'github_mock_secret'
      }
    )
  end

  def mock_auth_hash_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '1235456789',
      info: {
        name: 'vkontakte user',
        email: 'user-vkontakte@example.com'
      },
      credentials: {
        token: 'vkontakte_mock_token',
        secret: 'vkontakte_mock_secret'
      }
    )
  end
end
