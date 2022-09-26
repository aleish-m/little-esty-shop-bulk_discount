require 'httparty'
require 'json'

class HolidayService

  def self.get_holidays
    return [{date: '12/25/2022', name: "Christmas Day - TEST"}, {date: '01/01/2023', name: "New Year's Day - TEST"}, {date: '02/14/2023', name: "Valentine's Day - TEST"}] if Rails.env == 'test'
    get_uri('https://date.nager.at/api/v3/NextPublicHolidays/US')
  end

  def self.get_uri(uri)
    data = HTTParty.get(uri, headers: true)
    parsed = JSON.parse(data.body, symbolize_names: true)
  end
end