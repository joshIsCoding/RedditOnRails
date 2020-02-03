class Sub < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  
  belongs_to(
    :moderator, 
    class_name: 'User', 
    foreign_key: :user_id,
    primary_key: :id
  )

end
