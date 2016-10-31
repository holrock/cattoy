module IntegrationTestHelpder
  def login_user(user)
    get "/login"
    assert_response :success
    post "/user_sessions", params: {email: users(:one).email, password: '12345678'}
    follow_redirect!
  end
end
