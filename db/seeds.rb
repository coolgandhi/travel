# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)
TravelerType.create!(traveler_type_id: "1",
             traveler_type_name: "Solo")
TravelerType.create!(traveler_type_id: "2",   
             traveler_type_name: "Couple")
TravelerType.create!(traveler_type_id: "3",   
              traveler_type_name: "Family")              
TravelerType.create!(traveler_type_id: "4",   
                traveler_type_name: "Group")
TravelerType.create!(traveler_type_id: "5",   
              traveler_type_name: "GirlsGetAway")
TravelerType.create!(traveler_type_id: "6",   
              traveler_type_name: "BackPacker")
              
ActivityType.create!(activity_type_id:"1", 
                     activity_name:"Food")
ActivityType.create!(activity_type_id:"2", 
                     activity_name:"Transport")
ActivityType.create!(activity_type_id:"3", 
                     activity_name:"Location")  
                     
TransportType.create!(transport_type_id: "1",
                      transport_name: "Car")                   
TransportType.create!(transport_type_id: "2",
                      transport_name: "Public")
TransportType.create!(transport_type_id: "3",
                      transport_name: "Walk")

ActivityTimeType.create!(activity_time_type_id:"1", 
                     activity_period:"Early Morning")
ActivityTimeType.create!(activity_time_type_id:"2", 
                     activity_period:"Morning")
ActivityTimeType.create!(activity_time_type_id:"3", 
                     activity_period:"Noon")
ActivityTimeType.create!(activity_time_type_id:"4", 
                    activity_period:"Afternoon")
ActivityTimeType.create!(activity_time_type_id:"5", 
                    activity_period:"Evening")
ActivityTimeType.create!(activity_time_type_id:"6", 
                    activity_period:"Night")
ActivityTimeType.create!(activity_time_type_id:"7", 
                    activity_period:"Late Night")