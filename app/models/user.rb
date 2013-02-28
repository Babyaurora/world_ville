# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  unique_id       :string(255)      not null
#  display_name    :string(255)      not null
#  email           :string(255)
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  user_type       :integer          not null
#  coins           :integer
#  admin           :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  attr_accessible :unique_id, :display_name, :email, :password, :password_confirmation, :user_type
  has_secure_password
  
  before_save { email.downcase! }
  before_save :create_session_token
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :unique_id, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :display_name, presence: true, length: { maximum: 20 }
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  #0: person, 1: shop, 2: community
  validates :user_type, presence: true, inclusion: { in: [0, 1, 2] }
  
  private
  
  def create_session_token
    self.session_token = SecureRandom.urlsafe_base64
  end
end
