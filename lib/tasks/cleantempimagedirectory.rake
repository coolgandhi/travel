namespace :carrierwave do
  desc "Clean out temp CarrierWave files"
  task :clean_temp_image_directory do
    CarrierWave.configure do |config|
      cachedir = Rails.root.join("public", "#{config.cache_dir}", "*")
      puts "Carrier Wave temp Directory: #{cachedir}"
      iter = 0
      Dir.glob(cachedir).
        select{|f| File.mtime(f) < (Time.now - 1.day) }.
        each{|f| puts "Directory to be deleted: #{f}"
        FileUtils.rm_rf(f) 
        iter = iter + 1}
      puts "#{iter} directories(older than 1 day) deleted"
    end
  end
end