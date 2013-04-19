class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:sender_id])
    current_user.receive!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).sender
    current_user.unreceive!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
