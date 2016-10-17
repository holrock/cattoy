class History < ApplicationRecord
  belongs_to :toy, inverse_of: :histories
  belongs_to :cat, inverse_of: :histories

  validates :toy, presence: true
  validates :cat, presence: true
  validates :rate, inclusion: { in: -1..1 }
end
