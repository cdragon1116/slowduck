module ChatroomsHelper
  def chatroom_name(chatroom)
    if chatroom.conversation?
      chatroom.conversation_with(current_user).username
    else 
      "#{chatroom.name}".html_safe
    end
  end
  def add_member_button(chatroom)
    if !chatroom.conversation?
      link_to edit_chatroom_path(chatroom), :title => '加人進聊天室', :class => 'add-user' do 
        "<i class='fas fa-user-plus fa-xs'></i>".html_safe
      end
    end
  end
end

