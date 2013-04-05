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
  
  has_many :create_stories, class_name: 'Story', foreign_key: :creator_id
  has_many :own_stories, class_name: 'Story', foreign_key: :owner_id, dependent: :destroy
  has_many :relationships, foreign_key: :receiver_id, dependent: :destroy 
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: :sender_id, dependent: :destroy
  has_many :senders, through: :relationships, source: :sender
  has_many :receivers, through: :reverse_relationships, source: :receiver
  has_many :friends, through: :relationships, source: :sender, conditions: "user_type = 0"
  has_many :attractions, through: :relationships, source: :sender, conditions: "user_type = 1"
  has_many :shops, through: :relationships, source: :sender, conditions: "user_type = 2"
  
  after_initialize :set_attraction_pwd
  before_save { email.downcase! }
  before_save :set_unique_id
  before_save :create_session_token
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :unique_id, presence: true, uniqueness: true, on: :save
  validates :display_name, presence: true, length: { maximum: 50 }
  validates :display_name, uniqueness: { scope: :user_type }, if: :attraction?                                      
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }, unless: :attraction?
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  #0: person, 1: attraction, 2: shop
  validates :user_type, presence: true, inclusion: { in: [0, 1, 2] }
  
  def feed(type = nil)
    Story.from_senders_of(self, type)
  end
  
  def own_feed
    Story.created_by(self)
  end
  
  def receiving?(other_user)
    relationships.find_by_sender_id(other_user.id)
  end

  def receive!(other_user)
    relationships.create!(sender_id: other_user.id)
  end
  
  def unreceive!(other_user)
    relationships.find_by_sender_id(other_user.id).destroy
  end
  
  def self.search(location, type)
    # TODO currently location is searched in display_name field, it should be searched within location related fields once map model is avaliable and location implementation is decided
    if type.blank?
      find(:all, :conditions => ['display_name LIKE ?', "%#{location}%"])
    else
      find(:all, :conditions => ['display_name LIKE ? and user_type = ?', "%#{location}%", type])
    end
  end
  
  private
  
  def set_attraction_pwd
    self.password = "foobar" if attraction?
    self.password_confirmation = "foobar" if attraction?
  end
  
  def create_session_token
    self.session_token = attraction?? '#' : SecureRandom.urlsafe_base64
  end
  
  def set_unique_id
    self.unique_id = attraction?? self.display_name : self.email
  end
  
  def attraction?
    user_type == 1
  end
end
