guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('spec/dummy/config/application.rb')
  watch('spec/dummy/config/environment.rb')
  watch(%r{^spec/dummy/config/environments/.+\.rb$})
  watch(%r{^spec/dummy/config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/dummy/Gemfile')
  watch('spec/dummy/Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'rspec', :cli => "--color --format doc --backtrace --drb", :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
