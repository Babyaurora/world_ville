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
  attr_accessible :display_name, :email, :password, :password_confirmation, :user_type
  has_secure_password
  has_many :stories, dependent: :destroy
  has_many :own_stories, class_name: 'Story', foreign_key: :to_user_id, dependent: :destroy
  
  after_initialize :set_community_pwd
  before_save { email.downcase! }
  before_save :set_unique_id
  before_save :create_session_token
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :unique_id, presence: true, uniqueness: true, on: :save
  validates :display_name, presence: true, length: { maximum: 50 }
  validates :display_name, uniqueness: { scope: :user_type }, if: :community?                                      
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: :community?
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  #0: person, 1: shop, 2: community
  validates :user_type, presence: true, inclusion: { in: [0, 1, 2] }
  
  def feed
    stories
  end
  
  private
  
  def set_community_pwd
    self.password = "foobar" if community?
    self.password_confirmation = "foobar" if community?
  end
  
  def create_session_token
    self.session_token = community?? '#' : SecureRandom.urlsafe_base64
  end
  
  def set_unique_id
    self.unique_id = community?? self.display_name : self.email
  end
  
  def community?
    user_type == 2
  end
end
