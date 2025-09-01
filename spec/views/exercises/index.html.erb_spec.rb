require 'rails_helper'

RSpec.describe "exercises/index", type: :view do
  before(:each) do
    user = User.create!(name: "ExerciseUser", email: "exerciseuser2@example.com", password: "password", password_confirmation: "password")
    workout = Workout.create!(title: "WorkoutTitle", user: user)
    assign(:exercises, [
      Exercise.create!(
        name: "Name",
        reps: 2,
        workout: workout
      ),
      Exercise.create!(
        name: "Name",
        reps: 2,
        workout: workout
      )
    ])
  end

  it "renders a list of exercises" do
    render
    assert_select 'table#exercises-table tbody tr', count: 2
    assert_select 'table#exercises-table', /Name/
    assert_select 'table#exercises-table', /2/
  # Workout title or id is shown, but we don't assert on it here
  end
end
