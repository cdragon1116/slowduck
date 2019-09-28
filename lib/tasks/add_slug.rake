namespace :db do
  desc 'add-slug-to-message'
  task :setImage => :environment do
    Message.find_each(&:save)
    Chatroom.find_each(&:save)
  end
end
