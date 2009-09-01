class ActiveRecord::Errors
  
  # Kopierad rakt av från AR,förutom att raden
  #   defaults = defaults.compact.flatten << :"messages.#{message}"
  # är ändrad till
  #   defaults = [:"messages.#{message}"] + defaults.compact.flatten
  # så den faktiskt fungerar. Fixat i Rails master, men inte i 2.3.2
  def generate_message(attribute, message = :invalid, options = {})
    message, options[:default] = options[:default], message if options[:default].is_a?(Symbol)
  
    defaults = @base.class.self_and_descendants_from_active_record.map do |klass|
      [ :"models.#{klass.name.underscore}.attributes.#{attribute}.#{message}", 
        :"models.#{klass.name.underscore}.#{message}" ]
    end
    
    defaults << options.delete(:default)
    defaults = [:"messages.#{message}"] + defaults.compact.flatten
  
    key = defaults.shift
    value = @base.respond_to?(attribute) ? @base.send(attribute) : nil
  
    options = { :default => defaults,
      :model => @base.class.human_name,
      :attribute => @base.class.human_attribute_name(attribute.to_s),
      :value => value,
      :scope => [:activerecord, :errors]
    }.merge(options)
  
    I18n.translate(key, options)
  end
end
