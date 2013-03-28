class StoriesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: :destroy
   
  def create
    @story = current_user.create_stories.build(params[:story])
    if @story.save
      flash[:success] = "Story created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @story.destroy
    redirect_to root_url
  end
  
  private
    
    def correct_user
    @story = current_user.create_stories.find_by_id(params[:id])
    redirect_to root_url if @story.nil?
  end

end
