# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'Paid to Go' do
    
    # Alamofire: Elegant networking in Swift
    # https://github.com/Alamofire/Alamofire
    pod 'Alamofire','~> 4.0'
    
    # ObjectMapper: A framweork to convert model objects to and from JSON
    # https://github.com/Hearst-DD/ObjectMapper/
    pod 'ObjectMapper', '~> 2.2.9'
    
    # Change navigation bar colors in animations and transitions
    # Github: https://github.com/DanisFabric/RainbowNavigation
    pod 'RainbowNavigation', '~> 1.1.0’
    
    # For avoiding keyboard when a textfield becomes first responder
    # Github: https://github.com/michaeltyson/TPKeyboardAvoiding
    pod 'TPKeyboardAvoiding', '~> 1.3’
    
    # Convenience method for creating autoreleased color using RGBA hex string.
    # Github: https://github.com/yeahdongcn/UIColor-Hex-Swift?files=1
    pod 'UIColor_Hex_Swift', '~> 3.0.1'
    
    # Asynchronous image loading framework.
    # Github: https://github.com/ibireme/YYWebImage
    pod 'YYWebImage', '~> 1.0.5’
    
    # SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.
    # Github https://github.com/SnapKit/SnapKit
    pod 'SnapKit', '~> 4.0.0'
    
    # REFrostedViewController is a lib for creating hamburguer side menu
    # github: https://github.com/romaonthego/REFrostedViewController
    pod 'REFrostedViewController', '~>  2.4.8'
    
    # Logger with colors, line in which the log takes place, etc.
    # https://github.com/DaveWoodCom/XCGLogger
    pod 'XCGLogger', '~> 6.0.2'
    
    # View Pager for iOS
    # https://github.com/kitasuke/PagingMenuController
    pod 'PagingMenuController'
    
    # KDCircularProgress
    # https://github.com/kaandedeoglu/KDCircularProgress
    pod 'KDCircularProgress'
    
    # Charts: Beautiful charts for iOS/tvOS/OSX!
    # https://github.com/danielgindi/Charts
    pod 'Charts'
    
    # MBProgressHud
    # https://github.com/jdg/MBProgressHUD
    pod 'MBProgressHUD', '~> 1.1.0'
    
    # DropDown
    # https://github.com/AssistoLab/DropDown
    pod 'DropDown'
    
    # FSPagerView
    # https://github.com/WenchaoD/FSPagerView
    pod 'FSPagerView'
    
    # Facebook
    
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    
    # SwiftDate
    # https://github.com/malcommac/SwiftDate
    pod 'SwiftDate', '~> 4.5.0'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
    
end

