guard :rspec, cmd: "bin/rspec" do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/user_auth/api.rb$}) { |m| "spec/api/" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
end
