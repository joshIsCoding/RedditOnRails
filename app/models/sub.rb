class Sub < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  validate :name_has_no_spaces_or_punctuation

  has_many :post_subs, inverse_of: :sub, dependent: :destroy
  has_many :posts, through: :post_subs do
    def sort_created_at
       order("posts.created_at DESC")
    end
  end

  belongs_to(
    :moderator, 
    class_name: 'User', 
    foreign_key: :user_id,
    primary_key: :id
  )

  private

  def name_has_no_spaces_or_punctuation
    if self.name
      unless self.name.match?(/^\w+$/)
        errors[:name] << "cannot contain spaces or punctuation"
      end
    end
  end
end
