require "test_helper"

class PostsVisibilityTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @published_post = posts(:published_post)
    @draft_post = posts(:draft_post)
  end

  test "public index hides drafts" do
    get posts_url
    assert_response :success
    assert_select "h2", text: @published_post.title
    assert_select "h2", text: @draft_post.title, count: 0
  end

  test "author sees own drafts" do
    sign_in @user
    get posts_url
    assert_response :success
    assert_select "h2", text: @draft_post.title
  end

  test "pagination" do
    12.times do |i|
      Post.create!(title: "Paginated Post #{i}", body: "Content", slug: "paginated-#{i}", published_at: Time.current, user: @user)
    end

    get posts_url
    assert_response :success
    assert_select "nav.pagy"
  end
end
