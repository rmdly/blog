require "application_system_test_case"

class CommentsSystemTest < ApplicationSystemTestCase
  test "add a comment" do
    post = posts(:published_post)
    visit post_url(post)

    fill_in "Your Name", with: "Jane"
    fill_in "Comment", with: "Loved this post"
    click_on "Post Comment"

    assert_text "Comment added"
    assert_text "Jane"
    assert_text "Loved this post"
  end

  test "delete comment link visible when logged in" do
    user = users(:one)
    post = posts(:published_post)

    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    visit post_url(post)
    assert_selector "a", text: "Delete comment"
  end
end
