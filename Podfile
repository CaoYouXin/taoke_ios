# Uncomment the next line to define a global platform for your project
platform :ios, '11.1'

target 'TaoKe' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TaoKe
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxViewModel'
  pod 'RxDataSources'
  
  pod 'CleanroomLogger'
  pod 'RestKit'
  pod 'HandyJSON'
  pod 'UIColor_Hex_Swift'
  
  pod 'Kingfisher'
  pod 'FontAwesomeKit'
  
  pod 'RAMAnimatedTabBarController'
  pod 'MJRefresh'
  pod 'GSKStretchyHeaderView'
  pod 'MEVFloatingButton'
  pod 'ImageSlideshow'
  pod 'ImageSlideshow/Kingfisher'
  pod 'TabLayoutView'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'HandyJSON'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
          end
          if target.name == 'RAMAnimatedTabBarController'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
          end
      end
  end
end
