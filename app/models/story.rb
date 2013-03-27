# == Schema Information
#
# Table name: stories
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer          not null
#  to_user_id :integer          not null
#  reply_id   :integer
#  rating     :integer          default(0)
#  reply_num  :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Story < ActiveRecord::Base
  attr_accessible :content, :to_user_id, :reply_id, :rating, :reply_num
  
  default_scope order: 'stories.created_at DESC'
  
  belongs_to :user
  belongs_to :owner_user, class_name: 'User', foreign_key: :to_user_id
  belongs_to :original_story, class_name: 'Story', foreign_key: :reply_id, counter_cache: :reply_num
  has_many :reply_stories, class_name: 'Story', foreign_key: :reply_id
 
  validates_presence_of :user_id, :to_user_id
  validates :content, presence: true, length: { maximum: 1000 }
  
end
