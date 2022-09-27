class ApplicationController < ActionController::Base
  before_action :holidays

  def holidays
    @holidays = HolidaySearch.holidays
  end
end
