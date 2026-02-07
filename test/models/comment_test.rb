require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "valid comment" do
    comment = Comment.new(body: "Nice!", author_name: "Test", post: posts(:published_post))
    assert comment.valid?
  end

  test "invalid without body" do
    comment = Comment.new(author_name: "Test", post: posts(:published_post))
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "invalid without author_name" do
    comment = Comment.new(body: "Nice!", post: posts(:published_post))
    assert_not comment.valid?
    assert_includes comment.errors[:author_name], "can't be blank"
  end

  test "belongs to post" do
    comment = comments(:one)
    assert_equal posts(:published_post), comment.post
  end

  test "destroying post destroys comments" do
    post = posts(:published_post)
    comment_count = post.comments.count
    assert comment_count > 0

    assert_difference("Comment.count", -comment_count) do
      post.destroy
    end
  end
end
