# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'TaoKe' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for TaoKe
  pod 'RxSwift',    '~> 4.0'
  pod 'RxCocoa',    '~> 4.0'
  pod 'RxViewModel'
  pod 'RxDataSources'
  pod 'RxSegue', :git => 'https://github.com/gnastnosaj/RxSegue.git'
  pod 'RxBus'
  pod 'RealmSwift'
  
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
  pod 'ELWaterFallLayout', :git => 'https://github.com/NicolasKim/ELWaterFallLayout.git'
  pod 'Toast-Swift', '~> 2.0.0'
  pod 'EAIntroView'
  pod 'QRCode'
  pod 'PYSearch'
  pod 'BTNavigationDropdownMenu', :git => 'https://github.com/zkrige/BTNavigationDropdownMenu.git'
  
  pod 'Bugly'
  
  # Alibc
  # source 'http://repo.baichuan-ios.taobao.com/baichuanSDK/AliBCSpecs.git'
  # pod 'AlibcTradeSDK', '~> 3.1'
  
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
          if target.name == 'Toast-Swift'
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
          end
      end
  end
end
