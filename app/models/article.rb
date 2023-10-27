class Article < ApplicationRecord
  belongs_to :user
  # un article doit toujours être associé à un utilisateur lors de sa création ou de sa mise à jour:
  validates :user, presence: true
    # Ajout activeStorage aux articles pour pouvoir faciliter
  # suppression images sur Cloudinary
  # has_many_attached :images, service: :cloudinary, dependent: :purge
  has_many_attached :images, dependent: :purge
  # L'option dependent: :destroy garantit que si un article est supprimé,
  # toutes les entrées correspondantes dans article_categories seront également supprimées
  has_many :article_categories, dependent: :destroy
  has_many :categories, through: :article_categories
end
