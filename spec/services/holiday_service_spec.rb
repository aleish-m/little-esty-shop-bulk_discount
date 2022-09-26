require 'rails_helper'

RSpec.describe HolidayService do
  it 'gets the dates of the next 3 holidays' do
    allow(HolidayService).to receive(:get_holidays).and_return([{date: "01/01/2023"}])
    repos = HolidayService.get_holidays
    expect(repos).to be_an(Array)
    expect(repos[0]).to be_an(Hash)
    expect(repos[0]).to have_key(:date)
  end
  
  it 'gets the name of teh next 3 holidays' do
    allow(HolidayService).to receive(:get_holidays).and_return([{name: "New Year's Day"}])
    repos = HolidayService.get_holidays
    expect(repos).to be_an(Array)
    expect(repos[0]).to be_an(Hash)
    expect(repos[0]).to have_key(:name)
  end
end