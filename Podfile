project 'VOAEveryday.xcodeproj'

# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
inhibit_all_warnings!

target 'VOAEveryday' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!
  pod 'Router_t', '~>0.1.0'
  pod 'AFNetworking'
  pod 'Masonry'
  pod 'QMUIKit'
  pod 'ReactiveCocoa', '2.5'
  pod 'YYModel'
  pod 'Xor_t', '~>0.0.1'
  pod 'OC_CWCarousel'
  pod 'KafkaRefresh'
  pod 'UMCCommon'
  pod 'UMCPush'
  pod 'UMCSecurityPlugins'
  # Pods for VOAEveryday

end
post_install do |installer|
  installer.pods_project.targets.each do |target|
 target.build_configurations.each do |config|
  if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
     end
   end
  end
end
