class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:sender_id])
    current_user.receive!(@user)
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).sender
    current_user.unreceive!(@user)
    redirect_to @user
  end
end
