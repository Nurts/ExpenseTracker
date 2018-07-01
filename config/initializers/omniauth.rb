OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['27026728464-l56tc2urr2gtl1ufvnvhlso51tqm7r97.apps.googleusercontent.com'], ENV['WBzu9JvRcDouiis4VJ4dWI80'], {client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}}
end 