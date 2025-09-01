require 'rails_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    assign(:user, User.create!(
      name: "Name",
      email: "showuser@example.com",
      password: "password",
      password_confirmation: "password"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Email/)
  expect(rendered).to match(/showuser@example.com/)
  end
end
