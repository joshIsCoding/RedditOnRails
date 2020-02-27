class Post < ApplicationRecord
  validates :title, presence: true
  validate :url, :url_is_valid
  
  has_many :post_subs, dependent: :destroy, inverse_of: :post
  has_many :subs, through: :post_subs
  has_many :sub_mods, through: :subs, source: :moderator
  
  has_many :comments, dependent: :destroy
  validates :subs, presence: true
  belongs_to :author, class_name: "User"


  def get_post_sub(sub)
    self.post_subs.find_by(sub: sub)
  end
  
  private
  def url_is_valid
    if self.url
      unless self.url.match?(/^\w+(((\.|\:|\?|\%|\$|\&)|\/+)\S+)+$/)
        errors[:url] << "that is not a valid url"
      end
    end
  end
end
