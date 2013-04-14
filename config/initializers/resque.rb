require "resque/failure/multiple"
require "resque/failure/redis"
require "resque/failure/exception_notification"

Resque::Failure::Multiple.classes = [ Resque::Failure::Redis, Resque::Failure::ExceptionNotification ]
Resque::Failure.backend = Resque::Failure::Multiple