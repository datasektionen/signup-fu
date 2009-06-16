class SignupFuFormBuilder < ActionView::Helpers::FormBuilder
  # include the ActionView helpers to use methods like check_box_tag and so on
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper
  
  def fields_for(record_or_name_or_array, *args, &block)
    options = args.extract_options!.merge(:builder => SignupFuFormBuilder)
    args << options
    super(record_or_name_or_array, *args, &block)
  end
  
  def generic(label, content, options = {})
    row(label, options) do
      content
    end
  end
  
  def text_field(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def password_field(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def select(method, choices, options = {}, html_options = {})
    row(method, options) do
      super(method, choices, options, html_options)
    end
  end
  
  def check_box(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def file_field(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def text_area(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def datetime_select(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def date_select(method, options = {})
    row(method, options) do
      super(method, options)
    end
  end
  
  def submit(method, options = {})
    output = "<li class=\"submit_li\">#{super(method, options)}"
  
    if options[:cancel_link]
      output += "<p> or #{options[:cancel_link]}</p>"
    end
    
    output += "</li>"
  end
  
  private
  def row(method, options = {}, &block)
    options[:caption] ||= method.to_s.humanize
    
    out = "<li>"
    out += "<label#{" class=\"" + options[:class] if options[:class]} for='#{object_name}_#{method}'>#{options[:caption]} #{"*" if options[:mandatory]}</label>#{yield}</li>\n"
  end
end