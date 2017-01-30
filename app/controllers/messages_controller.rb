class MessagesController < ApplicationController
  def create
    @room = Room.find params[:room_id]
    @message = Message.create! message_params.merge room: @room, user: current_user
    # ActionCable.server.broadcast "room_#{@message.room.id}", message: ApplicationController.render(@message)
    RoomChannel.broadcast_to @room, message: ApplicationController.render(@message)
  end

  def show
    @room = Room.find params[:id]
  end

  private
    def message_params
      params.require(:message).permit :body
    end
end
