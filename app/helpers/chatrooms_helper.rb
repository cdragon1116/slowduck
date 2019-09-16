module ChatroomsHelper
  def user_image(user)
    if user.image.attached?
      image_tag user.image, class: 'user-image'
    else
      image_tag ('default_user_image.png'), class: 'user-image'
    end
end
end
