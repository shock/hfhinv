# config/personal_env.rb is ignored in .gitignore.  Use it to override other initializations in development mode ONLY.
# For example, you can could create config/personal_env.rb and add this:
#
#   if defined?(MailSafe::Config)
#     MailSafe::Config.replacement_address = 'your_email@kandid.ly'
#     MailSafe::Config.internal_address_definition = lambda { |address| nil }
#   end

if File.exists?("#{Rails.root}/config/personal_env.rb")
  puts "Loading config/personal_env.rb"
  require "#{Rails.root}/config/personal_env.rb"
end
