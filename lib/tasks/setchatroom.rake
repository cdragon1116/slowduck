namespace :db do
  desc 'set-chatroom'
  task :setChatroom => :environment do
    User.all.each do |user|
        user.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default_user_image.png')), filename: 'default_user_img.png', content_type: 'image/png')
    end
  end
end
