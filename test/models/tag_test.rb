require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "valid tag" do
    tag = Tag.new(name: "testing")
    assert tag.valid?
  end

  test "invalid without name" do
    tag = Tag.new(name: "")
    assert_not tag.valid?
  end

  test "name must be unique" do
    Tag.create!(name: "unique")
    tag = Tag.new(name: "unique")
    assert_not tag.valid?
  end

  test "normalizes name to lowercase" do
    tag = Tag.create!(name: "  Go Lang  ")
    assert_equal "go lang", tag.name
  end

  test "has many posts through post_tags" do
    tag = tags(:ruby)
    assert_includes tag.posts, posts(:published_post)
  end
end
