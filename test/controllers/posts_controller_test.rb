require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:published_post)
    @user = users(:one)
  end

  test "index" do
    get posts_url
    assert_response :success
    assert_select "h1", "Posts"
    assert_select "article", minimum: 1
  end

  test "show" do
    get post_url(@post)
    assert_response :success
    assert_select "h1", @post.title
  end

  test "root routes to index" do
    get root_url
    assert_response :success
    assert_select "h1", "Posts"
  end

  test "new requires login" do
    get new_post_url
    assert_redirected_to new_session_path
  end

  test "create requires login" do
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { title: "Test", body: "Body" } }
    end
    assert_redirected_to new_session_path
  end

  test "edit requires login" do
    get edit_post_url(@post)
    assert_redirected_to new_session_path
  end

  test "update requires login" do
    patch post_url(@post), params: { post: { title: "Hacked" } }
    assert_redirected_to new_session_path
    @post.reload
    assert_not_equal "Hacked", @post.title
  end

  test "destroy requires login" do
    assert_no_difference("Post.count") do
      delete post_url(@post)
    end
    assert_redirected_to new_session_path
  end

  test "create with valid params" do
    sign_in @user
    assert_difference("Post.count") do
      post posts_url, params: { post: { title: "New Post", body: "New body" } }
    end
    created_post = Post.last
    assert_equal @user, created_post.user
    assert_redirected_to post_url(created_post)
  end

  test "create with invalid params" do
    sign_in @user
    assert_no_difference("Post.count") do
      post posts_url, params: { post: { title: "", body: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "update with valid params" do
    sign_in @user
    patch post_url(@post), params: { post: { title: "Updated Title" } }
    assert_redirected_to post_url(@post)
    @post.reload
    assert_equal "Updated Title", @post.title
  end

  test "update with invalid params" do
    sign_in @user
    patch post_url(@post), params: { post: { title: "" } }
    assert_response :unprocessable_entity
  end

  test "destroy" do
    sign_in @user
    assert_difference("Post.count", -1) do
      delete post_url(@post)
    end
    assert_redirected_to posts_url
  end
end
