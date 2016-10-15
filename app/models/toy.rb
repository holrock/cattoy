class Toy < ApplicationRecord
  has_many :histories, dependent: :destroy, inverse_of: :toy
end
