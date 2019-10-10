module MarkdownHelper
  require 'redcarpet'
  require 'rouge'
  # require 'rouge/plugins/redcarpet'
  require_dependency 'rouge/plugins/redcarpet'

  class Rouge::Renderer < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

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
    
    # 修正非code換行問題
    markdown_text.gsub!('<br>', '')

    # 修正code 縮排問題
    pattern = /(<\s*code[^>]*>)/
    ary = markdown_text.split(pattern)
    final_text = ary.map do |x|
      if x.start_with?("<code")
        x = x + "\r\n"
      else
        x
      end
    end
    return final_text.join("").html_safe
  end

  def stripdown(text)
    require 'redcarpet/render_strip'
    Redcarpet::Markdown.new(Redcarpet::Render::StripDown).render(text)
  end
end
