require 'xcpretty'
require 'cocoapods'

workspace_file = "EasyMappingExample.xcworkspace"

desc "Install dependencies"
task :dependencies do
  system("pod install")
end


namespace :test do

  desc "Run the EasyMapping Tests for iOS"
  task :ios do
    $ios_success = system("xcodebuild test -scheme 'iOS Tests' -workspace #{workspace_file} -destination 'name=iPhone 7' | xcpretty -tc; exit ${PIPESTATUS[0]}")
  end

  desc "Run the EasyMapping Tests for Mac OS X"
  task :osx do
    $osx_success = system("xcodebuild test -scheme 'OS X Tests' -workspace #{workspace_file} | xcpretty -tc; exit ${PIPESTATUS[0]}")
  end
end

desc "Run the EasyMapping Tests for iOS & Mac OS X"
task :test => ['dependencies','test:ios', 'test:osx'] do
  puts "\033[0;31m! iOS unit tests failed" unless $ios_success
  puts "\033[0;31m! OS X unit tests failed" unless $osx_success
  if $ios_success && $osx_success
    puts "\033[0;32m** All tests executed successfully"
    exit(0)
  else
    exit(-1)
  end
end

task :default => 'test'
