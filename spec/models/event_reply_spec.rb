require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventReply do
  before(:each) do
    @valid_attributes = {
    }
  end
  
  it { should belong_to(:event) }
  it { should validate_presence_of(:event).with_message('is required') }

end
