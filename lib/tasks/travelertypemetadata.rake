namespace :db do
  desc "Fill database with travelertype data"
  task :populate  => :environment do
    TravelerType.create(:traveler_type_id => "1",
                 :traveler_type_name => "Solo")
    TravelerType.create(:traveler_type_id => "2",   
                 :traveler_type_name => "Couple")
    TravelerType.create(:traveler_type_id => "3",   
                  :traveler_type_name => "Family")              
    TravelerType.create(:traveler_type_id => "4",   
                    :traveler_type_name => "Group")
    TravelerType.create(:traveler_type_id => "5",   
                  :traveler_type_name => "GirlsGetAway")
    TravelerType.create(:traveler_type_id => "6",   
                  :traveler_type_name => "BackPacker")
  end
end