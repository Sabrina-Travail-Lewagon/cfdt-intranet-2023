class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  # validation inclusion, garantit que le role spécifié est une des valeurs autorisés
  # validates :role, inclusion: { in: ROLES }

  # before_validation définira automatiquement le rôle par défaut sur user avant de valider l'utilisateur.
  before_validation :set_default_role

  # On stocke les rôles possibles
  enum role: [:user, :cse, :rh, :redacteur, :admin]
  # after_initialize :set_default_role, if: :new_record?
  # Ajout photo a l'utilisateur
  has_one_attached :photo
  has_many :articles

  private
  # On va mettre le role user par défaut
  # def set_default_role
  #   self.role ||= 'user'
  # end
  def set_default_role
    self.role ||= :user
  end
end
