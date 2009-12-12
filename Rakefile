desc "Make a release"
task :release do
  setup
  puts %x{xcodebuild -project CrashLogFinder.xcodeproj -configuration Release}
  puts %x{zip -r iPhoneCrashLogFinder_#{get_version.gsub(".", "_")}.zip build/Release/iPhoneCrashLogFinder.app}
  mv "iPhoneCrashLogFinder_#{get_version.gsub(".", "_")}.zip", "dist"
end

def setup
  if File.exists?("build")
    rm_r "build"
  end
end

def get_version
  contents = File.open("CrashLogFinder-Info.plist").read
  contents.match(/<key>CFBundleShortVersionString<\/key>.*\n.*<string>(.*)<\/string>/)[1].strip
end