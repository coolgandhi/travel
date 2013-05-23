namespace :db do
  desc "Fill database with location data"
  task :addlocation => :environment do
    Location.create(:city => "Inspire Me!", 
                    :country => "",
                    :latitude => "",
                    :longitude => "",
                    :place => "Inspire Me!",
                    :state => "", 
                    :location_id => "")
    Location.create(:city => "San Francisco", 
                    :country => "US",
                    :latitude => "37.77493",
                    :longitude => "-122.41942",
                    :place => "San Francisco",
                    :state => "CA", 
                    :location_id => "5391959")
    Location.create(:city => "New York",
                    :country => "US",
                    :latitude => "40.71427",
                    :longitude => "-74.00597",
                    :place => "New York",
                    :state => "NY",
                    :location_id => "5128581")
    Location.create(:city  => "Paris",
                      :country  => "FR",
                      :latitude  => "48.85341",
                      :longitude  => "2.3488",
                      :place  => "Paris",
                      :state  => "le-de-France",
                      :location_id  => "2988507")
    Location.create(:city  => "London",
                      :country  => "UK",
                      :latitude  => "51.50853",
                      :longitude  => "-0.12574",
                      :place  => "London",
                      :state  => "London",
                      :location_id  => "2643743")
    Location.create(:city  => "San Jose",
                      :country  => "US",
                      :latitude  => "37.33939",
                      :longitude  => "-121.89496",
                      :place  => "San Jose",
                      :state  => "CA",
                      :location_id  => "5392171")
  end
end
