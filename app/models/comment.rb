class Comment < ApplicationRecord
  validates :contents, presence: true
  
  belongs_to :author, class_name: "User"
  belongs_to :post
  scope :with_authors, -> do
    select("comments.*, users.username AS \"author_name\"")
    .joins(:author)
  end
  scope :sort_created, -> { order(created_at: :desc) }
end
