require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:rspec) do |t|
  t.rspec_opts = '-fd -b'
end

task default: [:rspec]
