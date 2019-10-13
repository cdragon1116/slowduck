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
      image_tag url_for(user.resize_image("#{size}x#{size}!")), class:"shadow-sm img-profile rounded-circle"
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
end
