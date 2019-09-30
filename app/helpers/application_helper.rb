module ApplicationHelper
  def markdown(text)
    options = {
      prettify: true,
      # filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" }
    }
    extensions = {
      lax_spacing: true,
      tables:             true,
      autolink:           true,
      highlight:          true,
      superscript:        true,
      disable_indented_code_blocks: true,
      space_after_headers: true,
      fenced_code_blocks: true
    }
    # renderer = Redcarpet::Render::HTML.new(options)
    renderer = Rouge::Renderer.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    # text = text.gsub("\r\n", "<br>").gsub("\n", '')
    markdown_text = markdown.render(text)
    markdown_text.gsub!('<br>', '')
    return markdown_text.html_safe
  end

  def stripdown(text)
    require 'redcarpet/render_strip'
    Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(text)
  end
end
