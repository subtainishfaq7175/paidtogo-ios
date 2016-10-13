# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Paid to Go' do
    
    # Alamofire: Elegant networking in Swift
    # https://github.com/Alamofire/Alamofire
    pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
    
    # ObjectMapper: A framweork to convert model objects to and from JSON
    # https://github.com/Hearst-DD/ObjectMapper/
    pod 'ObjectMapper', '~> 1.3'
    
    # Change navigation bar colors in animations and transitions
    # Github: https://github.com/DanisFabric/RainbowNavigation
    pod 'RainbowNavigation', '~> 1.1.0'
    
    # For avoiding keyboard when a textfield becomes first responder
    # Github: https://github.com/michaeltyson/TPKeyboardAvoiding
    pod 'TPKeyboardAvoiding', '~> 1.2'
    
    # Convenience method for creating autoreleased color using RGBA hex string.
    # Github: https://github.com/yeahdongcn/UIColor-Hex-Swift?files=1
    pod 'UIColor_Hex_Swift', '~> 1.9'
    
    # Asynchronous image loading framework.
    # Github: https://github.com/ibireme/YYWebImage
    pod 'YYWebImage', '~> 1.0'
    
    # SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.
    # Github https://github.com/SnapKit/SnapKit
    pod 'SnapKit', '~> 0.22.0'
    
    # REFrostedViewController is a lib for creating hamburguer side menu
    # github: https://github.com/romaonthego/REFrostedViewController
    pod 'REFrostedViewController', '~> 2.4'
    
    # Logger with colors, line in which the log takes place, etc.
    # https://github.com/DaveWoodCom/XCGLogger
    pod 'XCGLogger', '~> 3.2'
    
    # View Pager for iOS
    # https://github.com/kitasuke/PagingMenuController
    pod 'PagingMenuController'
    
    # KDCircularProgress
    # https://github.com/kaandedeoglu/KDCircularProgress
    pod 'KDCircularProgress', '~> 1.4.5'

    # Charts: Beautiful charts for iOS/tvOS/OSX!
    # https://github.com/danielgindi/Charts
    pod 'Charts', '~> 2.3.0'
    
    # MBProgressHud
    # https://github.com/jdg/MBProgressHUD
    pod 'MBProgressHUD', '~> 0.9.2'
    
    # Facebook
    pod 'FBSDKCoreKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKLoginKit'
    
    # SwiftDate
    # https://github.com/malcommac/SwiftDate
    pod 'SwiftDate', :git => 'https://github.com/malcommac/SwiftDate.git', :branch => 'feature/swift_23'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '2.3'
            end
        end
    end
    
end

