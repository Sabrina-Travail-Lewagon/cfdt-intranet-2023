class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category
  include PgSearch::Model

  pg_search_scope :search_by_title_and_content,
    against: [:title, :pdf_filenames],
    associated_against: {
      rich_text_rich_body: [:body]  # Utilisez :rich_text ici pour correspondre à la configuration par défaut d'Action Text
    },
    using: {
      tsearch: { prefix: true }
    }
  # un article doit toujours être associé à un utilisateur lors de sa création ou de sa mise à jour:
  validates :user, presence: true
  # Un article doit avoir un titre
  validates :title, presence: true, length: { minimum: 5 }
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
  before_save :extract_and_store_pdf_filenames
  after_save :extract_and_store_pdf_filenames
  after_update :extract_and_store_pdf_filenames

  private

  def extract_and_store_pdf_filenames
    if documents.any?
      self.pdf_filenames = documents.filter { |doc| doc.content_type == 'application/pdf' }
                                    .map(&:filename)
                                    .join("; ")
    end
  end
  # def send_new_article_email
  #   User.find_each do |user|
  #     ArticleMailer.new_article_email(self, user).deliver_now
  #   end
  # end
end
