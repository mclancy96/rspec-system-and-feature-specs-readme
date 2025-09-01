require 'rails_helper'

RSpec.describe "workouts/edit", type: :view do
  let(:user) {
    User.create!(name: "WorkoutUser", email: "workoutuser@example.com", password: "password", password_confirmation: "password")
  }
  let(:workout) {
    Workout.create!(
      title: "MyString",
      user: user
    )
  }

  before(:each) do
    assign(:workout, workout)
  end

  it "renders the edit workout form" do
    render

    assert_select "form[action=?][method=?]", workout_path(workout), "post" do

      assert_select "input[name=?]", "workout[title]"

    end
  end
end
