class Story < ActiveRecord::Base
  attr_accessible :content, :to_user_id, :reply_id, :rating, :reply_num
  
  belongs_to :user
  belongs_to :original_story, class_name: 'Story', foreign_key: :reply_id, counter_cache: :reply_num
  has_many :reply_stories, class_name: 'Story', foreign_key: :reply_id
 
  validates_presence_of :user_id, :to_user_id
  
end
