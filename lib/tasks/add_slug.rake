namespace :db do
  desc 'add-slug-to-message'
  task :addSlug => :environment do
    Message.find_each(&:save)
    Chatroom.find_each(&:save)
  end
end
