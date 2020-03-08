class Comment < ApplicationRecord
  include Votable
  validates :contents, presence: true
  
  belongs_to :author, class_name: "User"
  belongs_to :post
  belongs_to :parent_comment, class_name: "Comment", required: false

  has_many :child_comments, class_name: "Comment", foreign_key: "parent_comment_id"
  scope :with_authors, -> do
    select("comments.*, users.username AS \"author_name\"")
    .joins(:author)
  end
  scope :top_level, -> { where(parent_comment_id: nil) }
  scope :sort_created, -> { order(created_at: :desc) }
end
