class MessagesController < ApplicationController
  def create
    @message = current_user.messages.create! message_params
    redirect_to room_path @message.room
  end

  def show
    @room = Room.find params[:id]
  end

  private
    def message_params
      params.require(:message).permit :room_id, :body
    end
end
