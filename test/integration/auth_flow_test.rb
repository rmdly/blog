require "test_helper"

class AuthFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "full login, post creation, and logout cycle" do
    post session_url, params: { email_address: @user.email_address, password: "password" }
    assert_redirected_to root_url
    follow_redirect!
    assert_response :success

    get new_post_url
    assert_response :success

    post posts_url, params: { post: { title: "Auth Flow Post", body: "Created after login" } }
    created_post = Post.find_by(title: "Auth Flow Post")
    assert_not_nil created_post
    assert_equal @user, created_post.user
    assert_redirected_to post_url(created_post)

    delete session_url
    assert_redirected_to new_session_path

    get new_post_url
    assert_redirected_to new_session_path
  end

  test "login with wrong password" do
    post session_url, params: { email_address: @user.email_address, password: "wrong" }
    assert_redirected_to new_session_path
  end
end
