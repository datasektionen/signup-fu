class CustomField < ActiveRecord::Base
  has_many :values, :class_name => "CustomFieldValue", :foreign_key => 'custom_field_id'
end
