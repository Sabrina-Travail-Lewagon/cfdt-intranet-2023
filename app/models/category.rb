class Category < ApplicationRecord
  validates :nom, presence: true
  has_many :articles
  has_one_attached :image
  # Ajout de l'attribut pour la couleur de fond
  attribute :background_color, :string
end
