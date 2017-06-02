require "bundler/gem_tasks"
require "bundler/audit/task"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# Add current path and lib to the load path
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

Bundler::Audit::Task.new
RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

Dir.glob('lib/user_auth/tasks/*.rake').each { |r| import r }

namespace :ci do
  task :all do
    # Run rubocop on the current branches commit diff with master:
    # rubocop:disable Metrics/LineLength
    # system!("git diff-tree -r --no-commit-id --name-only master@\{u\} head | xargs ls -1 2>/dev/null | grep '\.rb$' | xargs rubocop")
    Rake::Task["rubocop"].invoke
    Rake::Task["spec"].invoke
    Rake::Task["bundle:audit"].invoke
  end
end

task default: ["ci:all"]
