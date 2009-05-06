require 'test_helper'

class EventReplyTest < ActiveSupport::TestCase
  should_belong_to(:event)
end
