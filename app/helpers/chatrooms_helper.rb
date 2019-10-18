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
      link_to edit_chatroom_path(chatroom), :title => '加人進聊天室', :class => 'add-user ml-2' do 
        "<i class='fas fa-user-plus fa-xs'></i>".html_safe
      end
    end
  end

  def user_state(user)
    if user.online?
      render 'shared/user_online', user: user
    else
      render 'shared/user_offline', user: user
    end
  end
end

