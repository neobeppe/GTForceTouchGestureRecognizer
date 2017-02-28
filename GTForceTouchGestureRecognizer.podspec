Pod::Spec.new do |s|
  s.name         = "GTForceTouchGestureRecognizer"
  s.version      = "1.0.0"
  s.summary      = "Lightweight library to use 3D touch as gesture recognizer on iOS"
  s.homepage     = "https://github.com/neobeppe/GTForceTouchGestureRecognizer"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Giuseppe Travasoni" => "giuseppe.travasoni@gmail.com" }
  s.social_media_url   = "https://twitter.com/neobeppe"
  s.ios.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/neobeppe/GTForceTouchGestureRecognizer.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
  s.frameworks  = "UIKit"
end
