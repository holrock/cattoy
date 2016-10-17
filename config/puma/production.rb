application_path = File.expand_path('../../..', __FILE__).to_s
directory application_path
bind "unix://var/tmp/sockets/puma.sock"
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }.to_i
threads threads_count, threads_count
environment ENV.fetch('RAILS_ENV') { 'production' }
