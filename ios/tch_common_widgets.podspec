#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint tch_common_widgets.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'tch_common_widgets'
  s.version          = '0.1.0'
  s.summary          = 'Flutter common widgets & theming package used by tomaschyly.'
  s.description      = <<-DESC
Flutter common widgets & theming package used by tomaschyly.
                       DESC
  s.homepage         = 'https://tomas-chyly.com/en/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'chyly@tomas-chyly.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

#   s.dependency 'MaterialComponents/TextControls+OutlinedTextAreas'
#   s.dependency 'MaterialComponents/TextControls+OutlinedTextFields'
#   s.dependency 'MaterialComponents/TextControls+OutlinedTextAreasTheming'
#   s.dependency 'MaterialComponents/TextControls+OutlinedTextFieldsTheming'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
