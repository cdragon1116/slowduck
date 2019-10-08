module DeviseHelper
 def devise_error_messages!
  return '' if resource.errors.empty?

  messages = resource.errors.values.flatten.map { |msg| content_tag(:li, msg) }.join

   html = <<-HTML
   <div class="alert alert-danger alert-block"> 
    <button class="close" type="button" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">×</span>
    </button>
    #{messages}
   </div>
   HTML

   html.html_safe
 end
 def devise_flash_notice(flash)
  return '' if flash.empty?

  messages = flash.map{|name, msg| content_tag(:li, msg)}.join

   html = <<-HTML
   <div class="alert alert-danger alert-block"> 
    <button class="close" type="button" data-dismiss="alert" aria-label="Close">
      <span aria-hidden="true">×</span>
    </button>
    #{messages}
   </div>
   HTML

   html.html_safe
   
 end
end
