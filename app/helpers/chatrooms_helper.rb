module ChatroomsHelper
  def chatroom_link(chatroom)
    if chatroom.room_type == 1
      chatroom.conversation_with(current_user).username
    else 
      link_to "#{chatroom.name}".html_safe, edit_chatroom_path(@chatroom)
    end
  end
end

