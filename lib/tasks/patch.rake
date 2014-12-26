# task download: :environment do 
#   require 'open-uri'
#   User.all.each do |user|
#     next unless user.has_avatar?
#     puts ".";
#     user.avatar.versions.each do |version|
#       name = "#{version.first.to_s}_#{user[:avatar]}"
#       open(File.join(Rails.root, 'public', 'uploads', 'user', 'avatar', user.id.to_s, name), 'wb') do |file|
#         file << open("https://sidestage.s3.amazonaws.com/uploads/user/avatar/#{user.id}/#{name}").read
#       end
#     end
#   end
# end