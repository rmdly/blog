author = User.find_or_create_by!(email_address: "author@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

tags = %w[ruby rails javascript python devops tutorial].map do |name|
  Tag.find_or_create_by!(name: name)
end

post_content = [
  { title: "That time I mass-deleted a production table", body: "So last Tuesday I ran a DELETE without a WHERE clause on the orders table. In production. At 2pm on a weekday. I sat there for about five seconds watching the query run before I realized what was happening. Here's how we recovered and what I changed about my workflow so it never happens again." },
  { title: "Stop mocking everything", body: "I used to mock every external dependency in my tests. The database, HTTP calls, even other classes in the same app. The result was a test suite that passed with flying colours and an app that was completely broken. These days I only mock at the system boundary and I sleep much better." },
  { title: "The index you forgot to add", body: "Looked into why our dashboard was taking 8 seconds to load. Turned out we had a WHERE clause on a column with no index. Added the index, load time dropped to 200ms. This is maybe the most common performance fix in web apps and it's always the last thing people check." }
]

post_content.each_with_index do |content, i|
  post = author.posts.find_or_create_by!(title: content[:title]) do |p|
    p.body = content[:body]
    p.published_at = (3 - i).days.ago
  end

  post.tags = tags.sample(rand(1..3))
end

Post.published.limit(10).each do |post|
  rand(1..4).times do |j|
    post.comments.find_or_create_by!(author_name: "Reader #{j + 1}") do |c|
      c.body = "Great post about #{post.title.downcase}!"
    end
  end
end
