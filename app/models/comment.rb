class Comment < ApplicationRecord
  validates :contents, presence: true
  
  belongs_to :author, class_name: "User", dependent: :destroy
  belongs_to :post, dependent: :destroy
end
