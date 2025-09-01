# Example RSpec file for system and feature specs (pure Ruby)
#
# Instructions:
# 1. This lesson is about system/feature specs, but here is a Ruby example.
# 2. Try writing your own specs for user-like flows!

RSpec.describe 'System/Feature Example' do
  it 'simulates a user action' do
    result = [1,2,3].map { |n| n * 2 }
    expect(result).to eq([2,4,6])
  end
end
