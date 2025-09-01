require 'rails_helper'

RSpec.describe "workouts/show", type: :view do
  before(:each) do
    user = User.create!(name: "WorkoutUser", email: "workoutuser4@example.com", password: "password", password_confirmation: "password")
    assign(:workout, Workout.create!(
      title: "Title",
      user: user
    ))
  end

  it "renders attributes in <p>" do
    render
  expect(rendered).to match(/Title/)
  end
end
