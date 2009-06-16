require 'test_helper'

class EventReplyTest < ActiveSupport::TestCase
  should_belong_to(:event)
  should_validate_presence_of(:name, :email, :message => 'is required')
  # TODO validering på email
end
