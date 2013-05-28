require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :db do
   
  desc "Update existing provider column to normal in authorinfo"
  task :update_existing_provider_column_to_normal_in_authorinfo => :environment do

    i = 0
    j = 0
    AuthorInfo.all.each { |author_info|
      if author_info.provider.blank?
        author_info.provider = 'normal'
        if author_info.save
          i = i + 1
        else
          j = j + 1
        end
      end
    }
    
    puts " #{i} Authors updates successful #{j} failed"
  end
end