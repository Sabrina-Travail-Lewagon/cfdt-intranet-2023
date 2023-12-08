class Article < ApplicationRecord
  belongs_to :user
  belongs_to :category
  include PgSearch::Model

  pg_search_scope :search_by_title_and_content,
    against: [:title, :extracted_text],
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
  after_save :extract_and_store_pdf_text

  private

  def extract_and_store_pdf_text
    # Mise à jour de la colonne extracted_text uniquement si des PDFs sont attachés
    if documents.any?
      self.extracted_text = documents.filter { |doc| doc.content_type == 'application/pdf' }
                                     .map { |pdf| extract_text_from_pdf(pdf) }
                                     .compact
                                     .join("\n\n")
      save
    end
  end

  def extract_text_from_pdf(pdf)
    require 'pdf-reader'

    text = ""
    begin
      # Télécharge le fichier PDF et extrait le texte
      downloaded_pdf = pdf.download
      reader = PDF::Reader.new(downloaded_pdf)
      reader.pages.each do |page|
        text += page.text
      end
    rescue PDF::Reader::MalformedPDFError, PDF::Reader::UnsupportedFeatureError, ActiveStorage::FileNotFoundError => e
      Rails.logger.error "PDF extraction error: #{e}"
      text = "Erreur lors de l'extraction du texte du PDF."
    end
    text
  end
  # def send_new_article_email
  #   User.find_each do |user|
  #     ArticleMailer.new_article_email(self, user).deliver_now
  #   end
  # end
end
