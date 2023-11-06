class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :article
  validates :content, presence: true
  # Un commentaire doit faire au moins 200 caractères
  validates :content, length: { minimum: 200 }
end
