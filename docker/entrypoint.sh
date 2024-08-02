#! /bin/bash
./docker/wait-for.sh -t 0 db:3306 --strict -- echo "Database Engine is up"
bundle exec rails db:exists && rails db:migrate:with_data || rails db:create db:migrate
./docker/wait-for.sh -t 0 elasticsearch:9200 --strict -- echo "Elasticsearch Engine is up"
bundle exec rails searchkick:reindex:all

rm /app/tmp/pids/server.pid

puma -C config/puma.rb
