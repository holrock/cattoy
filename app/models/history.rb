class History < ApplicationRecord
  belongs_to :toy, inverse_of: :histories
  belongs_to :cat, inverse_of: :histories

  validates :rate, inclusion: { in: -1..1 }
end
