require 'rouge/plugins/redcarpet'

class HTMLwithPygments < Redcarpet::Render::HTML
  # to use Rouge with Redcarpet
  include Rouge::Plugins::Redcarpet

  def rouge_formatter(opts={})
    opts ={
      line_numbers: true,
      wrap: true,
    }
    Rouge::Formatters::HTML.new(opts)
  end

  # overriding Redcarpet method
  # github.com/vmg/redcarpet/blob/master/lib/redcarpet/render_man.rb#L9
  def block_code(code, language)
    Rouge.highlight(code, language || 'text', 'html')
  end
end
