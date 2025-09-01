class Exercise < ApplicationRecord
  belongs_to :workout
  validates :name, presence: true
  validates :reps, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
