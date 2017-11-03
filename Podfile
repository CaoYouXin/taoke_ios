# Uncomment the next line to define a global platform for your project
platform :ios, '11.1'

target 'TaoKe' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TaoKe
  pod 'RxSwift'
  pod 'RxCocoa'
  
  pod 'CleanroomLogger'
  pod 'RestKit'
  
  pod 'SDWebImage'
  pod 'FontAwesomeKit'
  
  pod 'RAMAnimatedTabBarController'
  pod 'PullToRefresher'
  pod 'GSKStretchyHeaderView'
  pod 'ImageSlideshow'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'RAMAnimatedTabBarController'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
          end
      end
  end
end
