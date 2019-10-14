module TagsHelper
  def scan(body)
    scan_tag(scan_user(body)).html_safe
  end

  def scan_user(body)
    pattern = /(@\S+)/
    ary =  body.split(pattern)
    recipients = []
    new_ary = ary.map do |user|
      if user.start_with?('@') and find_user = User.find_by(username: user.sub('@', '').sub(',', '') )
          render_user = ApplicationController.renderer.render( partial:'users/user', locals: {user: user} )
      else
        user
      end
    end
    return new_ary.join('')
  end

  def scan_tag(body)
    pattern = /(#\S+)/
    ary =  body.split(pattern)
    new_ary = ary.map do |tag|
      tag_ary = tag.split("")
      if tag_ary.select{|x| x == '#'}.length == 1 and !tag_ary.include?(' ')
        render_tag = ApplicationController.renderer.render( partial:'tags/tag', locals: {tag: tag} )
      else
        tag
      end
    end
    return new_ary.join('')
  end
end

