addEventListener "turbolinks:load", ->
  room_id = $("[data-room-id]").data("room-id")
  if room_id
    console.log "subscribing to room #{room_id}"
    App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: room_id },
      received: (data) ->
        $("[data-role~=messages]").append(data.message)
        window.scrollToEndOfMessages()

addEventListener "turbolinks:before-cache", ->
  if App.room
    console.log "unsubscribing from #{App.room.identifier}"
    App.room.unsubscribe()
    App.room = null
