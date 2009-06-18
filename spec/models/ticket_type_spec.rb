require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe TicketType do
  before(:each) do
    @valid_attributes = {
    }
  end
  
  it { should belong_to(:event) }
  
  it do
    Factory(:ticket_type)
    should validate_uniqueness_of(:name).scoped_to(:event_id)
  end
  
  it { should validate_numericality_of(:price) }
end
