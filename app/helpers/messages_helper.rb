module MessagesHelper
  def edit_buttons(message, current_user)
    if message.user.id == current_user.id
      '<button class="update_message_btn btn d-none"><i class="fas fa-check"></i></button><button class="edit_message_btn btn"><i class="fas fa-edit"></i></button>'.html_safe
    end
  end

  def color(color)
    ary = ['text-secondary', 'text-primary', 'text-success', 'text-warning']
    return ary[color]
  end

  def user_image(user, size)
    if user.image.attached? 
      image_tag url_for(user.resize_image(size)), class:"shadow-sm img-profile rounded-circle"
    else
      "<i class='fas fa-user-circle fa-lg text-dark' style='width:#{size}px; height:#{size}px; vertical-align: middle;'></i>".html_safe
    end
  end

  def message_icon(message)
    if message.parent_id == message.id
      link_to "<i class='fa fa-comment #{color(message.color)} mt-3' aria-hidden='true'></i>".html_safe, message_path(message.slug)
    else
      link_to "<i class='fa fa-share #{color(message.color)} mt-3' aria-hidden='true'></i>".html_safe , message_path(message.parent.slug)
    end
  end

  def process(message)
    if message.updated_at.to_s == message.created_at.to_s
      markdown(scan(message.body))
    else
      update_time = message.updated_at.strftime(' %H:%M')
      markdown(scan(message.body)) + "<span class='edited'> - 已編輯#{update_time}</span>".html_safe
    end
  end

  def render_date(message)
    start_message_of_day = message.chatroom.messages.order(created_at: :asc).group_by{ |t| t.created_at.to_date }.map{|k, v| v[0].id}
    if start_message_of_day.include?( message.id )
      render 'messages/message_with_date', message: message
    else
      render 'messages/message_without_date', message: message
    end
  end

  def get_date(message)
    message.created_at.strftime(' %m月%d日')
  end

  def message_image(message)
    image_types = ['image/jpeg', 'image/gif', 'image/png']
    if message.image.attached? and image_types.include?(message.image.blob.content_type)
      image_tag url_for( message.resize_image ), :class => 'message_image'
    end
  end
end
