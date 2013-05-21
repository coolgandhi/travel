require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :db do 
  desc "Recreate New Image Versions"
  task :recreate_new_image_version => :environment do
   
#    ImageUploader::process_self_image_upload = true 
    i = 0
    AuthorInfo.all.each do |author|
      if !author.self_image.blank?
        # author.self_image.cache_stored_file!
        # author.self_image.retrieve_from_cache!(author.self_image.cache_name) 
        
        author.self_image.recreate_versions!
        i = i+1
        # author.save!
      end
    end
    
    puts "#{i} author images recreated \n"
    i = 0
    SelfTripActivityPhoto.all.each do |activity_photo|
      if !activity_photo.self_photo.blank?
        activity_photo.self_photo.recreate_versions!
        i = i + 1
      end
    end    
    puts "#{i} trip activity photo recreated \n"

    i = 0
    Trip.all.each do |trip|
      if !trip.self_image.blank?
        trip.self_image.recreate_versions!
        i = i + 1
      end
    end    
    puts "#{i} trip photo recreated \n"
  end
end