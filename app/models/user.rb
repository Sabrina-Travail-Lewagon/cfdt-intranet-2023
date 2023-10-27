class User < ApplicationRecord
  ROLES = ['admin', 'user', 'rh', 'cse', 'redacteur'] # On stocke les rôles possibles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :photo
  validates :first_name, presence: true
  validates :last_name, presence: true
  # validation inclusion, garantit que le role spécifié est une des valeurs autorisés
  validates :role, inclusion: { in: ROLES }
  # before_validation définira automatiquement le rôle par défaut sur user avant de valider l'utilisateur.
  before_validation :set_default_role

  private
  # On va mettre le role user par défaut
  def set_default_role
    self.role ||= 'user'
  end
end
