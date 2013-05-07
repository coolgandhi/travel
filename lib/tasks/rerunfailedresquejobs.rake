require "resque/tasks"
#namespace :db do
  desc "Rerun failed resque jobs"
  task "resque:rerun_failed_job" => :environment do
    count = Resque::Failure.count
    puts "number of failed jobs #{count}"
    Resque::Failure.all(0,count).each { |job|
       puts "#{job["exception"]}  #{job["backtrace"]}"
    }
    (Resque::Failure.count-1).downto(0).each { |i|
      puts "requeuing  job #{i}"
      Resque::Failure.requeue(i) }
    Resque::Failure.clear
  end
#end