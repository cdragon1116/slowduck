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

    # 修正換行問題
    sub_text = text.gsub("\n ", '')
    markdown_text = markdown.render(sub_text)

    p_pattern = /(<p[^>]*>.*?<\/p>)/
    p_ary = markdown_text.split(p_pattern)
    p_final_text = p_ary.map do |x|
      if x.start_with?("<p")
        x.gsub('<br><br>', '<br>')
      else
        x
      end
    end
   
    # 修正code 縮排問題
    code_pattern = /(<\s*code[^>]*>)/
    ary = p_final_text.join('').split(code_pattern)
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
