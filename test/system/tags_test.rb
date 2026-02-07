require "application_system_test_case"

class TagsSystemTest < ApplicationSystemTestCase
  test "tags on show page" do
    post = posts(:published_post)
    visit post_url(post)
    assert_selector ".tag", text: "ruby"
    assert_selector ".tag", text: "rails"
  end

  test "click tag to filter" do
    visit posts_url
    click_on "ruby"
    assert_selector "article", minimum: 1
    assert_text "Published Post"
  end

  test "create post with tags" do
    user = users(:one)
    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    click_on "New Post"
    fill_in "Title", with: "Tagged System Post"
    fill_in "Body", with: "Post with tags"
    fill_in "Tags (comma-separated)", with: "elixir, phoenix"
    click_on "Create Post"

    assert_text "Post created"
    assert_selector ".tag", text: "elixir"
    assert_selector ".tag", text: "phoenix"
  end
end
