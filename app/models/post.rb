class Post < ApplicationRecord
  belongs_to :user, optional: true
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :body, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && title.present? }

  scope :published, -> { where.not(published_at: nil).where("published_at <= ?", Time.current) }
  scope :draft, -> { where(published_at: nil) }
  scope :recent, -> { order(created_at: :desc) }

  def to_param
    slug
  end

  def published?
    published_at.present? && published_at <= Time.current
  end

  def draft?
    !published?
  end

  def tag_list
    tags.pluck(:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map { |name| name.strip.downcase }.reject(&:blank?).uniq.map do |name|
      Tag.find_or_create_by!(name: name)
    end
  end

  private
    def generate_slug
      base_slug = title.parameterize
      candidate = base_slug
      counter = 2
      while Post.where(slug: candidate).where.not(id: id).exists?
        candidate = "#{base_slug}-#{counter}"
        counter += 1
      end
      self.slug = candidate
    end
end
