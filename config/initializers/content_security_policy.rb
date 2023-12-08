# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
#   config.content_security_policy do |policy|
#     policy.default_src :self, :https
#     policy.font_src    :self, :https, :data
#     policy.img_src     :self, :https, :data
#     policy.object_src  :none
#     policy.script_src  :self, :https
#     policy.style_src   :self, :https
#     # Specify URI for violation reports
#     # policy.report_uri "/csp-violation-report-endpoint"
#   end
#
#   # Generate session nonces for permitted importmap and inline scripts
#   config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
#   config.content_security_policy_nonce_directives = %w(script-src)
#
#   # Report violations without enforcing the policy.
#   # config.content_security_policy_report_only = true
# end
# config/initializers/content_security_policy.rb

Rails.application.config.content_security_policy do |policy|
  # Default 'self' for everything else
  policy.default_src :self

  # Allow images from 'self' and Cloudinary
  policy.img_src :self, :data, 'http://res.cloudinary.com/dooup7bi2/image/upload/', 'blob:'
  # Allow blob URLs for PDFs
  policy.object_src :self, 'blob:'

  # Scripts and styles for the text editor
  # You might need to add specific hashes or nonces if your text editor uses inline scripts or styles
  policy.script_src :self, :unsafe_inline

  # Update style-src to include Google Fonts
  policy.style_src :self, :unsafe_inline, 'https://fonts.googleapis.com'
  policy.font_src :self, :data, 'https://fonts.gstatic.com'

  # Include other source directives as needed
  # ...

  # Uncomment report_uri if you want to ensure that violations are reported
  # policy.report_uri "/csp-violation-report-endpoint"
  #policy.report_uri "/csp_violation_report"
end

# Uncomment if you want to use Content Security Policy in report-only mode for testing
#Rails.application.config.content_security_policy_report_only = true
