addEventListener "turbolinks:load", ->
  App.room = App.cable.subscriptions.create { channel: "RoomChannel", room_id: $("[data-room-id]").data("room-id") },
    received: (data) ->
      $("[data-role~=messages]").append(data.message)
