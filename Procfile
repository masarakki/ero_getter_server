web: bundle exec rackup -p $PORT
worker: bundle exec rake resque:work COUNT=$WORKER QUEUE=ero_getter
