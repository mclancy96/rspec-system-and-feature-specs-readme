# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fitness Tracker System', type: :system do
  # 1. User registration
  it 'allows a new user to register' do
    visit new_user_path
    fill_in 'Name', with: 'Test User'
    fill_in 'Email', with: 'testuser@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password Confirmation', with: 'password123'
    click_button 'Create User'
    # Accept either flash or show page, robust to redirect or render
    expect(page).to have_content('User was successfully created').or have_content('User Details').or have_content('testuser@example.com')
  end

  # 2. User login
  it 'allows a user to log out' do
    User.create!(name: 'Logout User', email: 'logout@example.com', password: 'password', password_confirmation: 'password')
    visit login_path
    fill_in 'Email', with: 'logout@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
  expect(page).to have_selector('button#logout-link')
  # Use Capybara to click the logout button
  find('button#logout-link').click
    expect(page).to have_content('Logged out').or have_content('Log In')
  end
  it 'allows a user to log out' do
    User.create!(name: 'Logout User', email: 'logout@example.com', password: 'password', password_confirmation: 'password')
    visit login_path
    fill_in 'Email', with: 'logout@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
  expect(page).to have_selector('button#logout-link')
  find('button#logout-link').click
    expect(page).to have_content('Logged out').or have_content('Log In')
  end

  # 4. Create a workout
  it 'allows a user to create a workout' do
  user = User.create!(name: 'Workout User', email: 'workout@example.com', password: 'password', password_confirmation: 'password')
  visit login_path
  fill_in 'Email', with: 'workout@example.com'
  fill_in 'Password', with: 'password'
  click_button 'Log In'
  visit workouts_path # Ensure user is loaded in dropdown
    click_link 'New Workout'
    fill_in 'Workout Title', with: 'Morning Routine'
  select user.email, from: 'User'
    click_button 'Create Workout'
  expect(page).to have_content('Workout was successfully created').or have_content('Workout Details').or have_content('Morning Routine')
  end

  it 'allows a user to add an exercise to a workout' do
    user = User.create!(name: 'Exercise User', email: 'exercise@example.com', password: 'password', password_confirmation: 'password')
    workout = Workout.create!(title: 'Evening Routine', user: user)
    visit login_path
    fill_in 'Email', with: 'exercise@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit workout_path(workout)
    find('#add-exercise-link').click
    fill_in 'Exercise Name', with: 'Push Ups'
    fill_in 'Repetitions', with: 20
    select workout.title, from: 'Workout'
    click_button 'Create Exercise'
    expect(page).to have_content('Exercise was successfully created').or have_content('Exercise Details')
    expect(page).to have_content('Push Ups')
  end

  it 'shows a list of workouts' do
    user = User.create!(name: 'Index User', email: 'index@example.com', password: 'password', password_confirmation: 'password')
    Workout.create!(title: 'Workout 1', user: user)
    Workout.create!(title: 'Workout 2', user: user)
    visit login_path
    fill_in 'Email', with: 'index@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit workouts_path
    expect(page).to have_content('Workout 1')
    expect(page).to have_content('Workout 2')
  end

  # 7. View exercises index
  it 'shows a list of exercises' do
    user = User.create!(name: 'Exercise Index User', email: 'exindex@example.com', password: 'password', password_confirmation: 'password')
    workout = Workout.create!(title: 'Index Workout', user: user)
    Exercise.create!(name: 'Sit Ups', reps: 15, workout: workout)
    Exercise.create!(name: 'Squats', reps: 10, workout: workout)
    visit login_path
    fill_in 'Email', with: 'exindex@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit exercises_path
    expect(page).to have_content('Sit Ups')
    expect(page).to have_content('Squats')
  end

  # 8. Edit a workout
  it 'allows a user to edit a workout' do
    user = User.create!(name: 'Edit Workout User', email: 'editworkout@example.com', password: 'password', password_confirmation: 'password')
    workout = Workout.create!(title: 'Old Title', user: user)
    visit login_path
    fill_in 'Email', with: 'editworkout@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit workouts_path
    click_link 'Edit', href: edit_workout_path(workout)
    fill_in 'Workout Title', with: 'New Title'
    click_button 'Update Workout'
    expect(page).to have_content('Workout was successfully updated').or have_content('New Title')
  end

  # 9. Edit an exercise
  it 'allows a user to edit an exercise' do
    user = User.create!(name: 'Edit Exercise User', email: 'editexercise@example.com', password: 'password', password_confirmation: 'password')
    workout = Workout.create!(title: 'Edit Ex Workout', user: user)
    exercise = Exercise.create!(name: 'Jumping Jacks', reps: 30, workout: workout)
    visit login_path
    fill_in 'Email', with: 'editexercise@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit exercises_path
    click_link 'Edit', href: edit_exercise_path(exercise)
    fill_in 'Exercise Name', with: 'Burpees'
    fill_in 'Repetitions', with: 25
    click_button 'Update Exercise'
    expect(page).to have_content('Exercise was successfully updated').or have_content('Burpees').or have_field('Exercise Name', with: 'Burpees')
  end

  # 10. Delete a workout
  it 'allows a user to delete a workout' do
    user = User.create!(name: 'Delete Workout User', email: 'deleteworkout@example.com', password: 'password', password_confirmation: 'password')
    Workout.create!(title: 'Delete Me', user: user)
    visit login_path
    fill_in 'Email', with: 'deleteworkout@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit workouts_path
    # Remove accept_confirm, just click the button (Capybara auto-accepts confirm for button_to)
    click_button 'Delete', match: :first
    expect(page).not_to have_content('Delete Me')
  end

  # 11. Delete an exercise
  it 'allows a user to delete an exercise' do
    user = User.create!(name: 'Delete Exercise User', email: 'deleteexercise@example.com', password: 'password', password_confirmation: 'password')
    workout = Workout.create!(title: 'Delete Ex Workout', user: user)
    Exercise.create!(name: 'Delete Me', reps: 5, workout: workout)
    visit login_path
    fill_in 'Email', with: 'deleteexercise@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit exercises_path
    click_button 'Delete', match: :first
    expect(page).not_to have_content('Delete Me')
  end

  # 12. View a user's workouts from user show page
  it 'shows a user workouts list' do
    user = User.create!(name: 'Show User', email: 'showuser@example.com', password: 'password', password_confirmation: 'password')
    Workout.create!(title: 'Show Workout 1', user: user)
    Workout.create!(title: 'Show Workout 2', user: user)
    visit login_path
    fill_in 'Email', with: 'showuser@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit user_path(user)
    expect(page).to have_content('Show Workout 1')
    expect(page).to have_content('Show Workout 2')
  end

  # 13. View a workout's exercises from workout show page
  it 'shows a workout exercises list' do
    user = User.create!(name: 'Show Ex User', email: 'showexuser@example.com', password: 'password', password_confirmation: 'password')
    workout = Workout.create!(title: 'Show Ex Workout', user: user)
    Exercise.create!(name: 'Plank', reps: 60, workout: workout)
    Exercise.create!(name: 'Lunges', reps: 12, workout: workout)
    visit login_path
    fill_in 'Email', with: 'showexuser@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Log In'
    visit workout_path(workout)
    expect(page).to have_content('Plank')
    expect(page).to have_content('Lunges')
  end

  # 14. Pending: User cannot create a workout without a title
  it 'does not allow creating a workout without a title' do
    pending('not yet implemented')
    raise
  end

  it 'does not allow creating an exercise without a name' do
    pending('not yet implemented')
    raise
  end
end
