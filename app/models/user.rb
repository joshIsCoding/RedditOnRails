class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, allow_nil: true, length: { minimum: 5 } 
  after_initialize :ensure_session_token
  attr_reader :password

  has_many :subs, dependent: :destroy
  has_many :posts, foreign_key: :author_id, dependent: :destroy

  def self.find_by_credentials(username, password)
    user = self.find_by(username: username)
    return user if user && user.has_password?(password)
    nil
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def has_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  private
  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
