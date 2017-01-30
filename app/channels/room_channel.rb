class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find params[:room_id]
    logger.debug "#{current_user.name.inspect} subscribed to RoomChannel for #{room.name.inspect}"
    # stream_from "room_#{params[:room_id]}"
    stream_for room
  end
end
