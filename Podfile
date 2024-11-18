# Uncomment the next line to define a global platform for your project

# platform :ios, '11.0'

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
            end
        end
    end
end
target 'WorkDonation' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WorkDonation
  
  # Kakao	
pod 'KakaoSDKShare'
pod 'KakaoSDKTemplate'
pod 'KakaoSDKUser'
pod 'KakaoSDKAuth'
pod 'KakaoSDKCommon'


  # Reactive
  pod 'RxSwift'
  pod 'RxGesture'
  pod 'RxAlamofire'
	
# add pods for desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods
  # Firebase
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'

  # Network
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'CodableAlamofire'
  pod 'Moya'
  pod 'Moya/RxSwift'

  # Logs
  pod 'CocoaLumberjack/Swift'
  pod 'Then'

  # Image
  pod 'CropViewController'

  # Download and Caching Images
  pod 'Kingfisher'
  pod 'SDWebImage'

  # Keybaord
  pod 'IQKeyboardManagerSwift', '6.4.2'

  # UI
  pod 'XLPagerTabStrip'
  pod 'PopupDialog'
  pod 'JGProgressHUD'
  pod 'FSPagerView'
  pod 'IGListKit'
  pod 'DropDown'
  pod 'Hero'
  pod 'Segmentio'
  pod 'Cosmos'
  pod 'RangeSeekSlider'
  pod 'FSCalendar'
  pod 'YoutubePlayer-in-WKWebView'
  pod 'SwiftyIamport'
pod 'AdFitSDK'ㅂ저

end
