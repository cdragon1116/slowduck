module ChatroomsHelper
  def chatroom_link(chatroom)
    if chatroom.status == '1on1'
      chatroom.one_on_one(current_user).username
    else 
      link_to "#{chatroom.name}".html_safe, edit_chatroom_path(@chatroom)
    end
  end
end

