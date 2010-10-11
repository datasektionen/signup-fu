class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'start'
  def index
    if current_user.present?
      redirect_to events_path
    end
  end
end