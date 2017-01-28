class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create! message_params
    ActionCable.server.broadcast "room_#{@message.room.id}", message: ApplicationController.render(@message)
  end

  def show
    @room = Room.find params[:id]
  end

  private
    def message_params
      params.require(:message).permit :room_id, :body
    end
end
