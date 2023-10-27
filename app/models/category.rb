class Category < ApplicationRecord
  validates :nom, presence: true
  has_many :article_categories
  has_many :articles, through: :article_categories
  has_one_attached :image
end
