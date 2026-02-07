require "test_helper"

class TagsFlowTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "create post with tags" do
    sign_in @user

    post posts_url, params: { post: { title: "Tagged Post", body: "Content", tag_list: "ruby, testing" } }
    created_post = Post.find_by(title: "Tagged Post")
    assert_redirected_to post_url(created_post)
    follow_redirect!

    assert_select ".tags .tag", text: "ruby"
    assert_select ".tags .tag", text: "testing"
  end

  test "filter by tag" do
    get posts_url(tag: "ruby")
    assert_response :success
    assert_select "article", minimum: 1
    assert_select "h2", text: "Published Post"
  end

  test "filter by nonexistent tag" do
    get posts_url(tag: "nonexistent")
    assert_response :success
    assert_select "article", count: 0
  end

  test "update tags on a post" do
    sign_in @user
    post_record = posts(:published_post)

    patch post_url(post_record), params: { post: { tag_list: "python, go" } }
    assert_redirected_to post_url(post_record)
    post_record.reload

    assert_includes post_record.tags.pluck(:name), "python"
    assert_includes post_record.tags.pluck(:name), "go"
    assert_not_includes post_record.tags.pluck(:name), "ruby"
  end
end
