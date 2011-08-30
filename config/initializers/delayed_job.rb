# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 90000
Delayed::Worker.max_attempts = 100
Delayed::Worker.max_run_time = 200.minutes

