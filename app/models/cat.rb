class Cat < ApplicationRecord
  belongs_to :user, inverse_of: :cats
end
