App.chatrooms = App.cable.subscriptions.create "ChatroomsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    active_chatroom =  $("[data-behavior='messages'][data-chatroom-id='#{data.chatroom_id}']")
    if active_chatroom.length > 0
        active_chatroom.append(data.message)
        active_chatroom.animate { scrollTop: active_chatroom.prop('scrollHeight') }, 300
        if document.hidden && Notification.permission == "granted"
            new Notification( data.username, { body: data.body, icon:"https://cdn0.iconfinder.com/data/icons/social-messaging-ui-color-shapes/128/chat-circle-blue-512.png"})
            
    else
       $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}'] i").removeClass('d-none')
       $("[data-behavior='chatroom-link'][data-chatroom-id='#{data.chatroom_id}']").css("color":"#fff")

  send_message: (chatroom_id, message) ->
    @perform "send_message", {chatroom_id: chatroom_id, body: message}


