module ApplicationHelper
  def csrf_token
    form_string = '<input type="hidden" name="authenticity_token" '
    form_string << "value=\"#{form_authenticity_token}\"> "
    form_string.html_safe
  end
end
