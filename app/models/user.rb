class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, uniqueness: true

  # validation inclusion, garantit que le role spécifié est une des valeurs autorisés
  # validates :role, inclusion: { in: ROLES }
  # before_validation définira automatiquement le rôle par défaut sur user avant de valider l'utilisateur.
  before_validation :set_default_role
  after_create :send_welcome_email
  # On stocke les rôles possibles
  enum role: [:user, :cse, :rh, :redacteur, :admin]
  # Ajout photo a l'utilisateur
  has_one_attached :photo
  has_many :articles
  has_many :comments
  # Partie J'aime
  has_many :likes, dependent: :destroy # Quand on supprime un user, likes seront supprimés
  has_many :liked_articles, through: :likes, source: :article

  private
  # On va mettre le role user par défaut
  def set_default_role
    self.role ||= :user
  end

  def send_welcome_email
    token = self.set_reset_password_token
    UserMailer.with(user: self, token: token).welcome.deliver_now
  end

end
