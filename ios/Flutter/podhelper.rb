require 'json'

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join(__dir__, 'Generated.xcconfig'))
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get is executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting it, then run flutter pub get"
end

def flutter_install_all_ios_pods(flutter_application_path)
  root = flutter_root
  plugins_file = File.join(flutter_application_path, '.flutter-plugins-dependencies')
  return unless File.exist?(plugins_file)

  plugins = JSON.parse(File.read(plugins_file))["plugins"]["ios"]
  plugins.each do |plugin|
    pod plugin["name"], :path => File.expand_path(plugin["path"], flutter_application_path)
  end
end
