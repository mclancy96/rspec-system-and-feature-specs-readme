require 'rails_helper'

RSpec.describe "exercises/edit", type: :view do
  let(:user) {
    User.create!(name: "ExerciseUser", email: "exerciseuser@example.com", password: "password", password_confirmation: "password")
  }
  let(:workout) {
    Workout.create!(title: "WorkoutTitle", user: user)
  }
  let(:exercise) {
    Exercise.create!(
      name: "MyString",
      reps: 1,
      workout: workout
    )
  }

  before(:each) do
    assign(:exercise, exercise)
  end

  it "renders the edit exercise form" do
    render

    assert_select "form[action=?][method=?]", exercise_path(exercise), "post" do

      assert_select "input[name=?]", "exercise[name]"

      assert_select "input[name=?]", "exercise[reps]"

  assert_select "select[name=?]", "exercise[workout_id]"
    end
  end
end
