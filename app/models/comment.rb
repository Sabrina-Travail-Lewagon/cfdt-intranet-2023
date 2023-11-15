class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  # Valide que le contenu est présent
  validates :content, presence: { message: :empty }

  # Valide que le contenu a une longueur minimale de 10 caractères
  validates :content, length: { minimum: 10, message: :too_short }
  # :empty et :too_short sont des symboles qui correspondent à des clés de localisation.
end
