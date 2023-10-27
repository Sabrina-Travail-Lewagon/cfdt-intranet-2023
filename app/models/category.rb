class Category < ApplicationRecord
  validates :nom, presence: true
  has_many :articles
  has_one_attached :image
end
