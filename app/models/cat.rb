class Cat < ApplicationRecord
  belongs_to :user, inverse_of: :cats
  has_many :histories, dependent: :destroy, inverse_of: :toy
end
