module DeviseHelper
 def devise_error_messages!
  return '' if resource.errors.empty?

  messages = resource.errors.values.flatten.map { |msg| content_tag(:li, msg) }.join

   html = <<-HTML
   <div class="alert alert-danger alert-block"> 
    #{messages}
   </div>
   HTML

   html.html_safe
 end
 def devise_flash_notice(flash)
  return '' if flash.empty?

  messages = flash.map{|name, msg| content_tag(:li, msg)}.join

   html = <<-HTML
   <div class="alert alert-block"> 
    #{messages}
   </div>
   HTML

   html.html_safe
   
 end
end
