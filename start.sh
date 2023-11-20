#!/bin/bash
./bin/webpacker-dev-server &   # Start webpack-dev-server in the background
sleep 20                        # Sleep for 20 seconds (you can adjust this as needed)
rake db:create                  # Create the database
rake db:migrate                 # Run database migrations
rake db:seed                    # Seed the database
rails s -b 0.0.0.0              # Start the Rails server