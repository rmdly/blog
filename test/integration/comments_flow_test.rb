require "test_helper"

class CommentsFlowTest < ActionDispatch::IntegrationTest
  test "comment appears on post after creation" do
    post_record = posts(:published_post)

    post post_comments_url(post_record), params: { comment: { body: "Interesting read", author_name: "Alex" } }
    assert_redirected_to post_url(post_record)
    follow_redirect!
    assert_response :success
    assert_select ".comment", text: /Interesting read/
  end
end
