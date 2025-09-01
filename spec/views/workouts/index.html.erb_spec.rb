require 'rails_helper'

RSpec.describe "workouts/index", type: :view do
  before(:each) do
    user = User.create!(name: "WorkoutUser", email: "workoutuser2@example.com", password: "password", password_confirmation: "password")
    assign(:workouts, [
      Workout.create!(
        title: "Title",
        user: user
      ),
      Workout.create!(
        title: "Title",
        user: user
      )
    ])
  end

  it "renders a list of workouts" do
    render
    assert_select 'table#workouts-table tbody tr', count: 2
    assert_select 'table#workouts-table', /Title/
  # User name or id is shown, but we don't assert on it here
  end
end
