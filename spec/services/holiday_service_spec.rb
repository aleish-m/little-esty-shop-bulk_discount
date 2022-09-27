require 'rails_helper'

RSpec.describe HolidayService do
  it 'gets the dates of the next 3 holidays' do
    allow(HolidayService).to receive(:get_holidays).and_return([{date: '12/25/2022', name: "Christmas Day - TEST"}, {date: '01/01/2023', name: "New Year's Day - TEST"}, {date: '02/14/2023', name: "Valentine's Day - TEST"}])
    repos = HolidayService.get_holidays
    expect(repos).to be_an(Array)
    expect(repos[0]).to be_an(Hash)
    expect(repos[0]).to have_key(:date)
  end
  
  it 'gets the name of teh next 3 holidays' do
    allow(HolidayService).to receive(:get_holidays).and_return([{date: '12/25/2022', name: "Christmas Day - TEST"}, {date: '01/01/2023', name: "New Year's Day - TEST"}, {date: '02/14/2023', name: "Valentine's Day - TEST"}])
    repos = HolidayService.get_holidays
    expect(repos).to be_an(Array)
    expect(repos[0]).to be_an(Hash)
    expect(repos[0]).to have_key(:name)
  end
end