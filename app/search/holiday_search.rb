class HolidaySearch
  def self.holidays 
    repo_data ||= HolidayService.get_holidays
    repo_data[0..2].map do |holiday|
      Holiday.new(holiday)
    end
  end