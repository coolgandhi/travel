namespace :db do
  desc "Fill database with activitydurationtype data"
  task :seedactivitydurationtypedata  => :environment do
    ActivityDurationType.create(:activity_duration_type_id => "1", \
                                :activity_duration_name => "")
    ActivityDurationType.create(:activity_duration_type_id => "2", \
                                :activity_duration_name => "<1 hour")
    ActivityDurationType.create(:activity_duration_type_id => "3",   \
                                :activity_duration_name => "1-2 hours")              
    ActivityDurationType.create(:activity_duration_type_id => "4",   \
                                :activity_duration_name => "2-4 hours")
    ActivityDurationType.create(:activity_duration_type_id => "5",   \
                                :activity_duration_name => ">4 hours")
    ActivityDurationType.create(:activity_duration_type_id => "6",   \
                                :activity_duration_name => "full day")
  end
end