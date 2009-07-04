module MarkupHelper
  def button_link_to(*args, &block)
    if block_given?
      html_options = args[1] || {}
      args[1] = html_options
    else
      html_options = args[2] || {}
      args[2] = html_options
    end
    
    html_options[:class] = "button"
    
    link_to(*args, &block)
  end
end