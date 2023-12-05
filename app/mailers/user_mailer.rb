class UserMailer < ApplicationMailer
  layout 'bootstrap-mailer'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome

    @user = params[:user]
    @token = params[:token]
    # mail to: @user.email, subject: "Bonjour #{@user.first_name}"
    bootstrap_mail(
      subject: "Intranet CFDT Services - Votre compte",
      to: @user.email,
      from: 'webmaster@cfdt-services.fr',
      track_opens: 'true',
      message_stream: 'rails'
    )
  end
end
