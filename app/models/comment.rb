class Comment < ApplicationRecord
  belongs_to :post

  validates :body, presence: true
  validates :author_name, presence: true
end
