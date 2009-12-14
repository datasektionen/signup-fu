require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "show page" do
  it "should show a info box the first time a user shows the event" do
    assigns[:event] = Factory(:event, :getting_started_shown => false, :ticket_types => [Factory(:ticket_type)])
    render 'events/show'
    response.should have_tag("div#getting_started")
  end
  
  it "should not show the getting started box the when it has already been shown" do
    assigns[:event] = Factory(:event, :getting_started_shown => true, :ticket_types => [Factory(:ticket_type)])
    render 'events/show'
    response.should_not have_tag("div#getting_started")
  end
  
end