class StaticPagesController < ApplicationController

  def home
  end

  def show
    if show_params[:user_id] !~ /^[0-9]{9}@N[0-9]{2}/
      flash[:notice] = "Invalid user id format."
      redirect_to root_path
      return
    end

    begin
      @photos = flickr.photos.search(user_id: show_params[:user_id], per_page: '10', page: '1')
    rescue FlickRaw::FailedResponse
      flash[:notice] = "Unknown user."
      redirect_to root_path
      return
    end

    if @photos.count == 0
      flash[:notice] = "User does not have photos."
      redirect_to root_path
      return
    end
  end

  private

  def show_params
    params.require(:q).permit(:user_id)
  end
end