require "resque/tasks"

desc "Rerun failed resque jobs"
task "resque:rerun_failed_job" => :environment
  count = Resque::Failure.count
  Resque::Failure.all(0,count).each { |job|
     puts "#{job["exception"]}  #{job["backtrace"]}"
  }
  (Resque::Failure.count-1).downto(0).each 
  { |i| Resque::Failure.requeue(i) }
  Resque::Failure.clear
end
