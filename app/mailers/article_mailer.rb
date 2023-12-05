class ArticleMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.article_mailer.create.subject
  #
  def create
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  def new_article_email(article, user)
    @article = article
    @user = user # Utilisateurs destinataires

    bootstrap_mail(
      subject: "Intranet CFDT Services - Nouvel article disponible !",
      to: @user.email,
      from: 'webmaster@cfdt-services.fr',
      track_opens: 'true',
      message_stream: 'rails'
    )
  end
end
