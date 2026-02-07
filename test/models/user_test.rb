require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    user = User.new(email_address: "test@example.com", password: "password", password_confirmation: "password")
    assert user.valid?
  end

  test "invalid without email" do
    user = User.new(password: "password", password_confirmation: "password")
    assert_not user.valid?
  end

  test "invalid with duplicate email" do
    existing = users(:one)
    user = User.new(email_address: existing.email_address, password: "password", password_confirmation: "password")
    assert_not user.valid?
  end

  test "normalizes email to lowercase" do
    user = User.new(email_address: "TEST@EXAMPLE.COM", password: "password", password_confirmation: "password")
    assert_equal "test@example.com", user.email_address
  end

  test "has many posts" do
    user = users(:one)
    assert_respond_to user, :posts
    assert_includes user.posts, posts(:published_post)
  end

  test "destroying user destroys their posts" do
    user = users(:one)
    post_count = user.posts.count
    assert post_count > 0

    assert_difference("Post.count", -post_count) do
      user.destroy
    end
  end
end
