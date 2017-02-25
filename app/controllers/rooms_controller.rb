class RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def create
    @room = Room.where(name: room_params[:name].downcase).first_or_create!
    redirect_to room_path @room
  end

  def show
    @room = Room.preload(messages: :user).find params[:id]
    @page_title = @room.name
  end

  private
    def room_params
      params.require(:room).permit :name
    end
end
