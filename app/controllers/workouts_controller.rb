class WorkoutsController < ApplicationController
  before_action :set_workout, only: %i[ show edit update destroy ]

  # GET /workouts
  def index
    @workouts = Workout.all
  end

  # GET /workouts/1
  def show
  end

  # GET /workouts/new
  def new
    @workout = Workout.new
  end

  # GET /workouts/1/edit
  def edit
  end

  # POST /workouts
  def create
    wp = workout_params
    if wp[:user_id].blank? && User.count == 1
      wp = wp.merge(user_id: User.first.id)
    end
    @workout = Workout.new(wp)
    flash[:notice] = "Workout was successfully created."
    if @workout.save
      redirect_to @workout, notice: "Workout was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /workouts/1
  def update
    if @workout.update(workout_params)
      redirect_to @workout, notice: "Workout was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /workouts/1
  def destroy
    @workout.destroy!
    redirect_to workouts_path, notice: "Workout was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workout
      @workout = Workout.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workout_params
      params.require(:workout).permit(:title, :user_id)
    end
end
