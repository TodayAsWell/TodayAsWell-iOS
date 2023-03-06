import Foundation
import UIKit
import AVFoundation
import CoreLocation
import AudioToolbox
import SystemConfiguration
import GPUImage
import Photos

// MARK: - 앱 이름
let APP_NAME = "Today"

// MARK: - 나중에 인앱 결재 기능 넣으면 사용 할 것
let IAP_PRODUCT_ID = "com.today.pro"

let PHOTO_FRAMES_NUMBER = 8

// MARK: - 핀터 소계에 들어갈 것들
let listOfCameras = [
    "회색",
    "파랑",
    "검정",
    "민트",
    "핑크",
    "블루베리색",
    "브라운",
    "보라",
    "빨강",
    "카고"
]


// MARK: - 색상목록
let cameraColors = [
    hexValue(hex: "#ADAFB4"),
    hexValue(hex: "#66A7CF"),
    hexValue(hex: "#1E2329"),
    hexValue(hex: "#48CFAE"),
    hexValue(hex: "#FFADCB"),
    hexValue(hex: "#46455F"),
    hexValue(hex: "#C28957"),
    hexValue(hex: "#754CC3"),
    hexValue(hex: "#ED3326"),
    hexValue(hex: "#6E907B")
]



// MARK: - 필터 목록
//일반 필터
let saturationFlt = SaturationAdjustment()
let contrastFlt = ContrastAdjustment()
let exposureFlt = ExposureAdjustment()
let brightnessFlt = BrightnessAdjustment()
//블루 오션 필터
let whiteBalanceFlt = WhiteBalance()
let rgbaAdjustmentFlt = RGBAdjustment()
let blendFlt = AlphaBlend()
// 그것이 알고 싶다 필터
let pixelllateFlt = Pixellate()
// 하얀색 티비 필터
let halftoneFlt = Halftone()
// 하얀색 체크무니 필터
let crossHatchFlt = Crosshatch()
//주변이 검정색인 필터
let vignetteFlt = Vignette()
let toonFlt = ToonFilter()
let luminanceFlt = Luminance()
let luminanceThresholdFlt = LuminanceThreshold()
let colorInversionFlt = ColorInversion()
let monochromeFlt = MonochromeFilter()
//실패작소녀 필터
let falseColorFlt = FalseColor()
let hazeFlt = Haze()
let sepiaFlt = SepiaToneFilter()
let opacityFlt = OpacityAdjustment()
//슈렉 필터
let hueFlt = HueAdjustment()
//let Avatar
let swirlFlt = SwirlDistortion()
let gaussianBlurFlt = GaussianBlur()
let tiltShiftFlt = TiltShift()
let highlightsAndShadowsFlt = HighlightsAndShadows()
let solarizeFlt = Solarize()
//보라색 민트색 필터
let cgaColorspaceFlt = CGAColorspaceFilter()
//햐얀색 테두리 검은 색 배경 필터
let prewittEdgeDetectionFlt = PrewittEdgeDetection()

//종의 필터
let sketchFlt = SketchFilter()
//완전 하얀색 필터
let thresholdSketchFlt = ThresholdSketchFilter()
let kuwaharaFlt = KuwaharaFilter()



// MARK: - 확장자들
var hud = UIView()
var loadingCircle = UIImageView()
var toast = UILabel()

// MARK: HEX 값 변환기
func hexValue(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) { cString.remove(at: cString.startIndex) }
    if ((cString.count) != 6) { return UIColor.gray }
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


extension UIViewController {
    
    // MARK: - 로딩
    func showHUD() {
        hud.frame = CGRect(x:0, y:0,
                           width:view.frame.size.width,
                           height: view.frame.size.height)
        hud.backgroundColor = UIColor.white
        hud.alpha = 0.7
        view.addSubview(hud)
        
        loadingCircle.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        loadingCircle.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        loadingCircle.image = UIImage(named: "loading_circle")
        loadingCircle.contentMode = .scaleAspectFill
        loadingCircle.clipsToBounds = true
        animateLoadingCircle(imageView: loadingCircle, time: 0.8)
        view.addSubview(loadingCircle)
    }
    func animateLoadingCircle(imageView: UIImageView, time: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = -Double.pi * 2
        rotationAnimation.duration = time
        rotationAnimation.repeatCount = .infinity
        imageView.layer.add(rotationAnimation, forKey: nil)
    }
    func hideHUD() {
        hud.removeFromSuperview()
        loadingCircle.removeFromSuperview()
    }
    
    
    // MARK: - 경고
    func simpleAlert(_ mess:String) {
        let alert = UIAlertController(title: APP_NAME, message: mess, preferredStyle: .alert)
        let ok = UIAlertAction(title: "알겠습니다.", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 이미지 조정(수정이 필요함)
    func scaleImageToMaxWidth(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    // MARK: - 사운드 관련
    func playSound(_ soundName:String, ofType:String) {
        let filePath = Bundle.main.path(forResource: soundName, ofType: ofType)
        soundURL = URL(fileURLWithPath: filePath!)
        AudioServicesCreateSystemSoundID(soundURL! as CFURL, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
}


// ------------------------------------------------
// MARK: - 인터넷 연결 확인 할 경우
// ------------------------------------------------
public class Reachability {
    class func isInternetConnectionAvailable() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        // 셀룰러 관련
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}



// MARK: - 앨범 만들기
extension UIViewController {

    func savePhoto(image:UIImage, albumName:String, completion:((PHAsset?)->())? = nil) {
        func save() {
            if let album = findAlbum(albumName: albumName) {
                saveImage(image: image, album: album, completion: completion)
            } else {
                createAlbum(albumName: albumName, completion: { (collection) in
                    if let collection = collection {
                        self.saveImage(image: image, album: collection, completion: completion)
                    } else {
                        completion?(nil)
                    }})
            }
        }
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            save()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    save()
            }})
        }
    }
    
   
    func findAlbum(albumName: String) -> PHAssetCollection? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let fetchResult : PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        guard let photoAlbum = fetchResult.firstObject else {
            return nil
        }
        return photoAlbum
    }
    
    func createAlbum(albumName: String, completion: @escaping (PHAssetCollection?)->()) {
        var albumPlaceholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection }, completionHandler: { success, error in
                if success {
                    guard let placeholder = albumPlaceholder else {
                        completion(nil)
                        return
                    }
                    let fetchResult = PHAssetCollection.fetchAssetCollections(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                    guard let album = fetchResult.firstObject else {
                        completion(nil)
                        return
                    }
                    completion(album)
                } else {
                    completion(nil)
                }})
    }
    
    func saveImage(image: UIImage, album: PHAssetCollection, completion:((PHAsset?)->())? = nil) {
        var placeholder: PHObjectPlaceholder?
        PHPhotoLibrary.shared().performChanges({
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let albumChangeRequest = PHAssetCollectionChangeRequest(for: album),
                let photoPlaceholder = createAssetRequest.placeholderForCreatedAsset else { return }
            placeholder = photoPlaceholder
            let fastEnumeration = NSArray(array: [photoPlaceholder] as [PHObjectPlaceholder])
            albumChangeRequest.addAssets(fastEnumeration)
        }, completionHandler: { success, error in
            guard let placeholder = placeholder else {
                completion?(nil)
                return
            }
            if success {
                let assets:PHFetchResult<PHAsset> =  PHAsset.fetchAssets(withLocalIdentifiers: [placeholder.localIdentifier], options: nil)
                let asset:PHAsset? = assets.firstObject
                completion?(asset)
            } else {
                completion?(nil)
            }
        })
    }
    
}

// MARK: - 스테틱 만들기 귀찮아서 만든 변수들
var takenImage = UIImage()
var cameraInUse = 0
var mainScreen = UIScreen.main
var DEFAULTS = UserDefaults.standard
var proIAPmade = false
var soundURL: URL?
var soundID: SystemSoundID = 0
