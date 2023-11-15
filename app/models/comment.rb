class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  # Valide que le contenu est présent
  validates :content, presence: { message: 'Le commentaire ne peut pas être vide.' }

  # Valide que le contenu a une longueur minimale de 10 caractères
  validates :content, length: { minimum: 10, message: 'Le commentaire doit contenir au moins 10 caractères.' }
end
