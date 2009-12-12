desc "Make a release"
task :release do
  setup
  puts %x{xcodebuild -project CrashLogFinder.xcodeproj -configuration Release}
  mv "build/Release/iPhoneCrashLogFinder.app", "."
  puts %x{zip -r iPhoneCrashLogFinder_#{get_version.gsub(".", "_")}.zip iPhoneCrashLogFinder.app}
  mv "iPhoneCrashLogFinder_#{get_version.gsub(".", "_")}.zip", "dist"
  rm_r "iPhoneCrashLogFinder.app"
  FileUtils.ln_s("iPhoneCrashLogFinder_#{get_version.gsub(".", "_")}.zip", "dist/iPhoneCrashLogFinder_latest.zip")
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