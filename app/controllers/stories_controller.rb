class StoriesController < ApplicationController
  before_filter :signed_in_user
  before_filter :correct_user,   only: [:destroy, :edit, :update]
  
  def create
   @story = current_user.create_stories.build(params[:story])
    if @story.save
      flash.now[:success] = "Story created!"
      # TODO: try to append list item rather than refresh the list
      @my_feeds = current_user.create_stories.paginate(page: params[:page], per_page: 4, total_entries: 20)
    end
  end
  
  def edit
    @owner_id = @story.owner_id
  end

  def update
    if @story.update_attributes(params[:story])
      flash.now[:success] = "Successfully updated post."
    end
  end

  def destroy
    @story.destroy
    flash.now[:success] = "Successfully destroyed post."
  end
  
  private
    
  def correct_user
    @story = current_user.create_stories.find_by_id(params[:id])
    redirect_to root_url if @story.nil?
  end

end
