require "application_system_test_case"

class PostsSystemTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "browse posts" do
    visit posts_url
    assert_selector "h1", text: "Posts"
  end

  test "view a post" do
    post = posts(:published_post)
    visit posts_url
    click_on post.title
    assert_selector "h1", text: post.title
  end

  test "login link visible when logged out" do
    visit posts_url
    assert_selector "a", text: "Log in"
  end

  test "login" do
    visit new_session_url
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"
    assert_selector "a", text: "Log out"
  end

  test "create a post" do
    visit new_session_url
    fill_in "Email address", with: @user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    click_on "New Post"
    fill_in "Title", with: "System Test Post"
    fill_in "Body", with: "System test body content"
    click_on "Create Post"

    assert_text "Post created"
    assert_selector "h1", text: "System Test Post"
  end

  test "new post redirects to login when logged out" do
    visit new_post_url
    assert_selector "h1", text: "Sign in"
  end
end
