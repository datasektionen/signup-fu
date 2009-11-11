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
  
  def stylesheet(*styles)
    styles.each do |style|
      content_for(:head) do
        stylesheet_link_tag(style)
      end
    end
  end
  
  def javascript(*scripts)
    scripts.each do |script|
      content_for(:head) do
        javascript_include_tag(script)
      end
    end
  end
  
end