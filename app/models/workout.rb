class Workout < ApplicationRecord
  belongs_to :user
  has_many :exercises, dependent: :destroy
  validates :title, presence: true
end
