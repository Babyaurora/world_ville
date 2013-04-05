class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @story = current_user.create_stories.build 
      @my_feeds = current_user.own_feed.paginate(page: params[:page], per_page: 4, total_entries: 20)
      @friend_feeds = current_user.feed(0).paginate(page: params[:page], per_page: 4, total_entries: 20)
      @attraction_feeds = current_user.feed(1).paginate(page: params[:page], per_page: 4, total_entries: 20)
      @shop_feeds = current_user.feed(2).paginate(page: params[:page], per_page: 4, total_entries: 20)
    end
  end
  
  def contact
  end
  
  def about
  end

  def help
  end
end
