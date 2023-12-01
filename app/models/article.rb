class Article < ApplicationRecord
  after_create :send_new_article_email
  belongs_to :user
  belongs_to :category
  include PgSearch::Model

  pg_search_scope :search_by_title_and_content,
    against: [:title],
    associated_against: {
      rich_text_rich_body: [:body]  # Utilisez :rich_text ici pour correspondre à la configuration par défaut d'Action Text
    },
    using: {
      tsearch: { prefix: true }
    }
  # un article doit toujours être associé à un utilisateur lors de sa création ou de sa mise à jour:
  validates :user, presence: true
  # Ajout activeStorage aux articles pour pouvoir faciliter
  # suppression images sur Cloudinary
  # has_many_attached :images, service: :cloudinary, dependent: :purge
  has_many_attached :images, dependent: :purge
  # L'option dependent: :destroy garantit que si un article est supprimé,
  # toutes les entrées correspondantes dans article_categories seront également supprimées
  has_rich_text :rich_body
  # Ajout de pièces jointes aux article
  has_many_attached :documents, service: :local, dependent: :purge_later
  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user
  # Comptabilisation des likes
  def like_count
    likes.count
  end

  private

  def send_new_article_email
    User.find_each do |user|
      ArticleMailer.new_article_email(self, user).deliver_later
    end
  end
end
