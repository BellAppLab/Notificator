Pod::Spec.new do |s|
  s.name             = "Notificator"
  s.version          = "0.1.0"
  s.summary          = "Display notifications in your app using auto layout and Swift."
  s.description      = <<-DESC
Display notifications in your app using auto layout and Swift. Inspired by https://github.com/hyperoslo/Whisper and https://github.com/sferrini/SFSwiftNotification
                       DESC

  s.homepage         = "https://github.com/BellAppLab/Notificator"
  s.license          = 'MIT'
  s.author           = { "Bell App Lab" => "apps@bellapplab.com" }
  s.source           = { :git => "https://github.com/BellAppLab/Notificator.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BellAppLab'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit'
end
