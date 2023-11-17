# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/welcome
  def welcome
    # This is how you pass value to params[:user] inside mailer definition!
    UserMailer.with(user: User.first).welcome
  end
end
