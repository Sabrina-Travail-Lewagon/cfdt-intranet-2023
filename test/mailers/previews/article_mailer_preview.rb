# Preview all emails at http://localhost:3000/rails/mailers/article_mailer
class ArticleMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/article_mailer/create
  def create
    ArticleMailer.create
  end
  def new_article_email
    # Créez ici des instances d'article et d'utilisateur pour la prévisualisation
    article = Article.first || Article.new(title: "Titre de test", content: "Contenu de test")
    user = User.first || User.new(email: "test@example.com")

    ArticleMailer.new_article_email(article, user)
  end
end
