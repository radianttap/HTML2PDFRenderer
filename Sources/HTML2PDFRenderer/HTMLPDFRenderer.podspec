Pod::Spec.new do |s|
  s.name         = 'HTMLPDFRenderer'
  s.version      = '1.0'
  s.summary      = 'Generate paged PDF simply, from a given WKWebView or URL.'
  s.homepage     = 'https://github.com/radianttap/HTMLPDFRenderer'
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { 'Aleksandar Vacić' => 'radianttap.com' }
  s.social_media_url   			= "https://twitter.com/radiantav"
  s.ios.deployment_target 		= "9.0"
  s.source       = { :git => "https://github.com/radianttap/HTMLPDFRenderer.git" }
  s.source_files = '*.swift'
  s.frameworks   = 'UIKit'
end
