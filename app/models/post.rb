class Post < ApplicationRecord
  validates :title, presence: true
  validate :url, :url_is_valid
  belongs_to :sub
  belongs_to :author, class_name: "User"

  private
  def url_is_valid
    if self.url
      unless self.url.match?(/^\w+(((\.|\:|\?|\%|\$|\&)|\/+)\S+)+$/)
        errors[:url] << "that is not a valid url"
      end
    end
  end
end
