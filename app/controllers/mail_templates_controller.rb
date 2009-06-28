class MailTemplatesController < ApplicationController
  before_filter :load_parent, :only => [:new, :create]
  private
  
  def load_parent
    @event = Event.find(params[:event_id])
  end
end
