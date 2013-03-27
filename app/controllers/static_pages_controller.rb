class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @story = current_user.stories.build 
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
  def contact
  end
  
  def about
  end

  def help
  end
end
