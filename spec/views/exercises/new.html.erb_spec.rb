require 'rails_helper'

RSpec.describe "exercises/new", type: :view do
  before(:each) do
    user = User.create!(name: "ExerciseUser", email: "exerciseuser3@example.com", password: "password", password_confirmation: "password")
    workout = Workout.create!(title: "WorkoutTitle", user: user)
    assign(:exercise, Exercise.new(
      name: "MyString",
      reps: 1,
      workout: workout
    ))
  end

  it "renders new exercise form" do
    render

    assert_select "form[action=?][method=?]", exercises_path, "post" do

      assert_select "input[name=?]", "exercise[name]"

      assert_select "input[name=?]", "exercise[reps]"

  assert_select "select[name=?]", "exercise[workout_id]"
    end
  end
end
