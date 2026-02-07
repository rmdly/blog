require "test_helper"

class PostTagTest < ActiveSupport::TestCase
  test "post has tags through post_tags" do
    post = posts(:published_post)
    assert_includes post.tags, tags(:ruby)
    assert_includes post.tags, tags(:rails)
  end

  test "tag_list returns comma-separated tag names" do
    post = posts(:published_post)
    names = post.tag_list.split(", ")
    assert_includes names, "ruby"
    assert_includes names, "rails"
  end

  test "tag_list= assigns tags from comma-separated string" do
    post = posts(:draft_post)
    post.tag_list = "python, django, python"
    post.save!

    assert_equal 2, post.tags.count
    assert_includes post.tags.pluck(:name), "python"
    assert_includes post.tags.pluck(:name), "django"
  end

  test "tag_list= normalizes to lowercase" do
    post = posts(:draft_post)
    post.tag_list = "Ruby, RAILS"
    post.save!

    assert_includes post.tags.pluck(:name), "ruby"
    assert_includes post.tags.pluck(:name), "rails"
  end
end
