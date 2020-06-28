#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint khipu_pay.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'khipu_pay'
  s.version          = '1.0.1'
  s.summary          = 'Plugin to create payment identifiers, process payments and verify the status of a payment through the Khipu platform.'
  s.description      = <<-DESC
Plugin to create payment identifiers, process payments and verify the status of a payment through the Khipu platform.
                       DESC
  s.homepage         = 'https://github.com/DuckyTieDev/khipu_pay'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DuckyTie' => 'juan.vergara@duckytie.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'khenshin', '~> 1.702'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
