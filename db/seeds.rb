author = User.find_or_create_by!(email_address: "author@example.com") do |u|
  u.password = "password"
  u.password_confirmation = "password"
end

tags = %w[ruby rails javascript python devops tutorial].map do |name|
  Tag.find_or_create_by!(name: name)
end

5.times do |i|
  post = author.posts.find_or_create_by!(title: "Test Post #{i + 1}") do |p|
    p.body = "This is the content for post #{i + 1}."
    p.published_at = (5 - i).days.ago
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
