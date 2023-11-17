
class TestMailer < ApplicationMailer
  default from: 'sender@example.org'

  def hello
    mail(
      subject: 'Hello from Postmark',
      to: 'mouedines@cfdt-services.fr',
      from: 'mouedines@cfdt-services.fr',
      html_body: '<strong>Hello</strong> dear Postmark user.',
      track_opens: 'true',
      message_stream: 'broadcast')
  end
end
