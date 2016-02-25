module UsersHelper
  def sanitize_markdown(content)
    Sanitize.clean(markdown(content.body).truncate(500, separator: '', omission: '...').html_safe)
  end
end
