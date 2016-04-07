module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end


	def formatDate(date)
		date.strftime("%B %d %Y")
	end

  def markdown(text)
    render_options = {
      autolink: true,
      filter_html: false,
      no_intra_emphasis: true,
      space_after_headers: false,
      lax_spacing: true,
      hard_wrap: true,
      with_toc_data: true,
      lax_html_blocks: true,
      prettify: true,
      fenced_code_blocks: true,
      link_attributes: { rel: 'nofollow' },
      underline: true,
      quote: true,
      highlight: true,
      footnotes: true,
      strikethrough: true,
      superscript: true,
      tables: true
    }

    renderer = HTMLwithPygments.new(render_options)

    extensions = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }
    Redcarpet::Markdown.new(renderer, extensions).render(text).html_safe
  end
end

