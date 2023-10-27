class Category < ApplicationRecord
  validates :nom, presence: true
  has_one_attached :image
end
