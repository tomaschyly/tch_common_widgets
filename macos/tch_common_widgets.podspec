#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tch_common_widgets.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tch_common_widgets'
  s.version          = '0.0.2'
  s.summary          = 'Flutter common widgets & theming package used by tomaschyly.'
  s.description      = <<-DESC
Flutter common widgets & theming package used by tomaschyly.
                       DESC
  s.homepage         = 'https://tomas-chyly.com/en/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'chyly@tomas-chyly.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
