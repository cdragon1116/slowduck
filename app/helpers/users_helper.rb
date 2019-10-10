module UsersHelper
 def conversation_online?(chatroom, current_user) 
  if chatroom.conversation_with(current_user).online == 1
    return 'online' 
  else
    return 'offline'
  end
 end
end

