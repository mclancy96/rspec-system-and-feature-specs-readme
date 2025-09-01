class CreateExercises < ActiveRecord::Migration[8.0]
  def change
    create_table :exercises do |t|
      t.string :name
      t.integer :reps
      t.references :workout, null: false, foreign_key: true

      t.timestamps
    end
  end
end
