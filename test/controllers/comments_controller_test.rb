require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post = posts(:published_post)
    @user = users(:one)
    @comment = comments(:one)
  end

  test "anyone can create a comment with valid params" do
    assert_difference("Comment.count") do
      post post_comments_url(@post), params: { comment: { body: "New comment", author_name: "Visitor" } }
    end
    assert_redirected_to post_url(@post)
  end

  test "create with invalid params redirects with alert" do
    assert_no_difference("Comment.count") do
      post post_comments_url(@post), params: { comment: { body: "", author_name: "" } }
    end
    assert_redirected_to post_url(@post)
    follow_redirect!
    assert_select "#alert"
  end

  test "authenticated user can destroy comment" do
    sign_in @user
    assert_difference("Comment.count", -1) do
      delete post_comment_url(@post, @comment)
    end
    assert_redirected_to post_url(@post)
  end

  test "unauthenticated user cannot destroy comment" do
    assert_no_difference("Comment.count") do
      delete post_comment_url(@post, @comment)
    end
    assert_redirected_to new_session_path
  end
end
