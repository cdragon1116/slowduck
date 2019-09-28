module ChatroomsHelper
  def chatroom_link(chatroom)
    if chatroom.status == '1on1'
      "<h3 class='mb-0'>#{chatroom.one_on_one_name(current_user)}</h3>".html_safe
    else 
      link_to "<h3 class='mb-0'>#{chatroom.name}</h3>".html_safe, new_chatroom_chatroom_user_path(@chatroom), class:'nav-link text-dark'
    end
  end
end

