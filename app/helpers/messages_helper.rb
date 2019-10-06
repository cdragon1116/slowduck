module MessagesHelper
  def color(color)
    ary = ['text-secondary', 'text-primary', 'text-success', 'text-warning']
    return ary[color]
  end

  def user_image(user, size)
    if user.image.attached? 
      image_tag url_for(user.resize_image("#{size}x#{size}!")), class:"shadow-sm img-profile rounded-circle"
    else
      "<i class='fas fa-user-circle fa-lg text-dark' style='width:#{size}px; height:#{size}px; vertical-align: middle;'></i>".html_safe
    end
  end

  def message_icon(message)
    if message.parent_id == message.id
        link_to "<i class='fa fa-comment #{color(message.color)} mt-3' aria-hidden='true'></i>".html_safe, chatroom_message_path(message.chatroom.slug , message.slug)
    else
      link_to "<i class='fa fa-share #{color(message.color)} mt-3' aria-hidden='true'></i>".html_safe , chatroom_message_path(message.chatroom.slug, message.parent.slug)
    end
  end
end
