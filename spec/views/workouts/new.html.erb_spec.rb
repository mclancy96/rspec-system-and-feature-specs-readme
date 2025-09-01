require 'rails_helper'

RSpec.describe "workouts/new", type: :view do
  before(:each) do
    user = User.create!(name: "WorkoutUser", email: "workoutuser3@example.com", password: "password", password_confirmation: "password")
    assign(:workout, Workout.new(
      title: "MyString",
      user: user
    ))
  end

  it "renders new workout form" do
    render

    assert_select "form[action=?][method=?]", workouts_path, "post" do

      assert_select "input[name=?]", "workout[title]"

    end
  end
end
