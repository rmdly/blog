require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "valid post with all attributes" do
    post = Post.new(title: "Test", body: "Body text", slug: "test")
    assert post.valid?
  end

  test "invalid without title" do
    post = Post.new(body: "Body text")
    assert_not post.valid?
    assert_includes post.errors[:title], "can't be blank"
  end

  test "invalid without body" do
    post = Post.new(title: "Test")
    assert_not post.valid?
    assert_includes post.errors[:body], "can't be blank"
  end

  test "generates slug from title when blank" do
    post = Post.create!(title: "My First Post", body: "Content")
    assert_equal "my-first-post", post.slug
  end

  test "does not overwrite existing slug" do
    post = Post.create!(title: "My Post", body: "Content", slug: "custom-slug")
    assert_equal "custom-slug", post.slug
  end

  test "generates unique slug when duplicate exists" do
    Post.create!(title: "Duplicate", body: "First", slug: "duplicate")
    post2 = Post.create!(title: "Duplicate", body: "Second")
    assert_equal "duplicate-2", post2.slug
  end

  test "slug must be unique" do
    Post.create!(title: "First", body: "Body", slug: "same-slug")
    post2 = Post.new(title: "Second", body: "Body", slug: "same-slug")
    assert_not post2.valid?
    assert_includes post2.errors[:slug], "has already been taken"
  end

  test "to_param returns slug" do
    post = posts(:published_post)
    assert_equal "published-post", post.to_param
  end

  test "published scope returns only published posts" do
    published = Post.published
    assert_includes published, posts(:published_post)
    assert_includes published, posts(:another_published)
    assert_not_includes published, posts(:draft_post)
  end

  test "draft scope returns only draft posts" do
    drafts = Post.draft
    assert_includes drafts, posts(:draft_post)
    assert_not_includes drafts, posts(:published_post)
  end

  test "published? returns true for published post" do
    assert posts(:published_post).published?
  end

  test "published? returns false for draft post" do
    assert_not posts(:draft_post).published?
  end

  test "draft? returns true for draft post" do
    assert posts(:draft_post).draft?
  end

  test "draft? returns false for published post" do
    assert_not posts(:published_post).draft?
  end

  test "published? returns false for future published_at" do
    post = Post.new(title: "Future", body: "Body", published_at: 1.day.from_now)
    assert_not post.published?
  end
end
