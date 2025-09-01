require 'rails_helper'

RSpec.describe "exercises/show", type: :view do
  before(:each) do
    user = User.create!(name: "ExerciseUser", email: "exerciseuser4@example.com", password: "password", password_confirmation: "password")
    workout = Workout.create!(title: "WorkoutTitle", user: user)
    assign(:exercise, Exercise.create!(
      name: "Name",
      reps: 2,
      workout: workout
    ))
  end

  it "renders attributes in <p>" do
    render
  expect(rendered).to match(/Name/)
  expect(rendered).to match(/2/)
  end
end
