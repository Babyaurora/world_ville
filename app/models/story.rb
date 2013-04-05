# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  creator_id :integer          not null
#  owner_id   :integer          not null
#  reply_id   :integer
#  rating     :integer          default(0)
#  reply_num  :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Story < ActiveRecord::Base
  attr_accessible :content, :owner_id, :reply_id, :rating, :reply_num
  
  default_scope order: 'stories.created_at DESC'
  
  belongs_to :creator, class_name: "User"
  belongs_to :owner, class_name: 'User'
  belongs_to :original_story, class_name: 'Story', foreign_key: :reply_id, counter_cache: :reply_num
  has_many :reply_stories, class_name: 'Story', foreign_key: :reply_id
 
  validates_presence_of :creator_id, :owner_id
  validates :content, presence: true, length: { maximum: 1000 }
  
  def self.from_senders_of(user, type)
    sender_ids = case type
    when 0
      user.friend_ids
    when 1
      user.attraction_ids
    when 2
      user.shop_ids
    else
      user.sender_ids
    end
    where("owner_id IN (?)", sender_ids)
  end
  
  def self.created_by(user)
    where("creator_id = ?", user)
  end
  
end
