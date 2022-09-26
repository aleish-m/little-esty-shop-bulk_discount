require 'rails_helper'

RSpec.describe Holiday do
  it 'does exist' do
    holiday = Holiday.new(date: "12/25/2022", name: "Christmas Day")
    expect(holiday).to be_instance_of(Holiday)
    expect(holiday.date).to eq("12/25/2022")
    expect(holiday.name).to eq("Chistmas Day")
  end
end