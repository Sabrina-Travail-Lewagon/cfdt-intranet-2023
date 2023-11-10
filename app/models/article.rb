class Article < ApplicationRecord
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

  # Méthode de recherche qui inclut le surlignage
  def self.search_with_highlight(query)
    # Utilisez find_by_sql pour exécuter une requête SQL personnalisée
    find_by_sql([<<-SQL, query: "%#{sanitize_sql_like(query)}%"])
      SELECT
        articles.*,
        ts_headline('english', articles.title, plainto_tsquery(:query)) AS title_highlight,
        ts_headline('english', action_text_rich_texts.body, plainto_tsquery(:query)) AS content_highlight
      FROM
        articles
      INNER JOIN
        action_text_rich_texts ON action_text_rich_texts.record_id = articles.id
      WHERE
        action_text_rich_texts.record_type = 'Article' AND
        articles.title @@ plainto_tsquery(:query) OR
        action_text_rich_texts.body @@ plainto_tsquery(:query)
    SQL
  end
end
