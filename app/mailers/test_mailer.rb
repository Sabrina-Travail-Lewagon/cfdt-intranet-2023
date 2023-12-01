
class TestMailer < ApplicationMailer
  default from: 'sender@example.org'

  def hello
    mail(
      subject: 'Message d\'Intranet CFDT',
      to: 'mouedines@cfdt-services.fr',
      from: 'mouedines@cfdt-services.fr',
      html_body: '<strong>Bonjour</strong> cher utilisateur.',
      track_opens: 'true',
      message_stream: 'broadcast')
  end
end
