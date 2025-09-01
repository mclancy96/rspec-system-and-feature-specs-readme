require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        name: "Name",
        email: "user1@example.com",
        password: "password",
        password_confirmation: "password"
      ),
      User.create!(
        name: "Name",
        email: "user2@example.com",
        password: "password",
        password_confirmation: "password"
      )
    ])
  end

  it "renders a list of users" do
    render
    cell_selector = 'div>p'
  assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
  assert_select cell_selector, text: /user[12]@example.com/, count: 2
  end
end
