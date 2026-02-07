require "application_system_test_case"

class DraftVisibilityTest < ApplicationSystemTestCase
  test "drafts hidden from public" do
    visit posts_url
    assert_no_text "Draft Post"
  end

  test "author sees own drafts" do
    user = users(:one)
    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    visit posts_url
    assert_text "Draft Post"
  end

  test "publish a draft" do
    user = users(:one)
    draft = posts(:draft_post)

    visit new_session_url
    fill_in "Email address", with: user.email_address
    fill_in "Password", with: "password"
    click_on "Sign in"

    visit edit_post_url(draft)
    fill_in "Published at", with: Time.current.strftime("%Y-%m-%dT%H:%M")
    click_on "Update Post"

    assert_text "Post updated"
  end
end
