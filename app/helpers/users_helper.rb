module UsersHelper
 def conversation_online?(chatroom, current_user) 
  if chatroom.conversation_with(current_user).online?
    return 'online' 
  else
    return 'offline'
  end
 end
end

