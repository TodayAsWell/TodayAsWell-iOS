import UIKit
import Then
import SnapKit
import GPUImage
import RxSwift
import RxCocoa
import AVFoundation


@available(iOS 13.0, *)
class MainViewController: BaseVC {
    
    // MARK: - UIComponenets
    internal lazy var renderView = RenderView()
    
    internal lazy var ARButton = UIButton().then {
        let imageIcon = UIImage(systemName: "a.square")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        $0.setBackgroundImage(imageIcon, for: UIControl.State.normal)
    }
    
    internal lazy var pendingButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    internal lazy var timerButton = UIButton().then {
        
        let imageIcon = UIImage(systemName: "timer")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        $0.setBackgroundImage(imageIcon, for: UIControl.State.normal)
    }
    internal lazy var flashButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "cam_flash_off"), for: .normal)
    }
    internal lazy var swicthScreenButton = UIButton().then {
        let imageIcon = UIImage(systemName: "arrow.triangle.2.circlepath.camera")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        $0.setBackgroundImage(imageIcon, for: UIControl.State.normal)
    }
    
    internal lazy var shootButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "PhotoButtonOff"), for: .normal)
    }
    
    internal lazy var previewButton = UIButton()
    internal var previewImg = UIImageView()
    var imgInFrame = UIImageView()
    
    var filterButton = UIButton().then {
        let imageIcon = UIImage(systemName: "camera.filters")
        $0.setBackgroundImage(imageIcon, for: UIControl.State.normal)
    }
    
    internal var whiteFadingImg = UIImageView()
    var viewWithFrame = UIView()
    var camNameLabel: UILabel!
    
    var camera:Camera!

    var imgToShare = UIImage()
    var isFlashON = false
    var isFrontCamera = false
    
    // MARK: - FunctionFunctions
    //필터를 사용할거 넣는 함수
    func setCameraUIAndFilters() {
        print("CAMERA IN USE: \(cameraInUse)")
        
        // 필터들
        saturationFlt.removeAllTargets()
        contrastFlt.removeAllTargets()
        exposureFlt.removeAllTargets()
        brightnessFlt.removeAllTargets()
        whiteBalanceFlt.removeAllTargets()
        rgbaAdjustmentFlt.removeAllTargets()
        blendFlt.removeAllTargets()
        pixelllateFlt.removeAllTargets()
        halftoneFlt.removeAllTargets()
        crossHatchFlt.removeAllTargets()
        vignetteFlt.removeAllTargets()
        toonFlt.removeAllTargets()
        luminanceFlt.removeAllTargets()
        luminanceThresholdFlt.removeAllTargets()
        colorInversionFlt.removeAllTargets()
        monochromeFlt.removeAllTargets()
        falseColorFlt.removeAllTargets()
        hazeFlt.removeAllTargets()
        sepiaFlt.removeAllTargets()
        opacityFlt.removeAllTargets()
        hueFlt.removeAllTargets()
        swirlFlt.removeAllTargets()
        gaussianBlurFlt.removeAllTargets()
        tiltShiftFlt.removeAllTargets()
        highlightsAndShadowsFlt.removeAllTargets()
        solarizeFlt.removeAllTargets()
        cgaColorspaceFlt.removeAllTargets()
        prewittEdgeDetectionFlt.removeAllTargets()
        sketchFlt.removeAllTargets()
        thresholdSketchFlt.removeAllTargets()
        kuwaharaFlt.removeAllTargets()

        // 카메라 초기화
        do {
            if !isFrontCamera {
                camera = try Camera(sessionPreset: .photo, location: .backFacing)
                camera.delegate = self as? CameraDelegate
            } else {
                camera = try Camera(sessionPreset: .photo, location: .frontFacing)
                camera.delegate = self as? CameraDelegate
            }
                          
            switch cameraInUse {
                
            case 0:
                camera --> renderView
            case 1:
                whiteBalanceFlt.temperature = 4000
                camera --> saturationFlt --> whiteBalanceFlt --> renderView
            break
            default:break
            }
            camera.startCapture()
            
        } catch { fatalError("Could not initialize the Camera: \(error)") }
    }
    
    //후레시 버튼 클릭 했을 때
    func flashButtonDidTap() {
        if !isFrontCamera {
//            playSound("flash", ofType: "wav")
            
            isFlashON = !isFlashON
            print("플래시는 \(isFlashON) 상태입니다")
            
            if isFlashON {
                flashButton.setBackgroundImage(UIImage(named: "cam_flash_on"), for: .normal)
                do {
                    try camera.inputCamera.lockForConfiguration()
                    camera.inputCamera.torchMode = .off
                    camera.inputCamera.unlockForConfiguration()
                    print("플래시가 켜졌습니다")
                } catch {
                    print("\(error)")
                }
            } else {
                flashButton.setBackgroundImage(UIImage(named: "cam_flash_off"), for: .normal)
                do {
                    try camera.inputCamera.lockForConfiguration()
                    camera.inputCamera.torchMode = .off
                    camera.inputCamera.unlockForConfiguration()
                    print("플래시가 꺼졌습니닦")
                } catch {
                    print("\(error)")
                }
            }
        }
    }
    
    func shootPictureButtonDidTap() {

//        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        
        UIGraphicsBeginImageContextWithOptions(renderView.bounds.size, false, 0)
        renderView.drawHierarchy(in: renderView.bounds, afterScreenUpdates: true)
        takenImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        previewImg.image = takenImage
        imgInFrame.image = takenImage
//        saveImageWithFrame()
        
        shootButton.isEnabled = false
        whiteFadingImg.alpha = 1
        
        UIView.animate(withDuration: 2.0, delay: 1.5, options: .curveLinear, animations: {
//            self.playSound("roll_picture", ofType: "wav")
            self.whiteFadingImg.alpha = 0
            
        }, completion: { (finished: Bool) in
            self.shootButton.isEnabled = true
        })
    }

//    func saveImageWithFrame() {
//        UIGraphicsBeginImageContextWithOptions(viewWithFrame.bounds.size, false, 0)
//        viewWithFrame.drawHierarchy(in: viewWithFrame.bounds, afterScreenUpdates: true)
//        imgToShare = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
//        UIGraphicsEndImageContext()
//
//        // Save photo into a custom folder in the Camera Roll
//        savePhoto(image: imgToShare, albumName: APP_NAME, completion: nil)
//    }

    func swicthScreenButtonDidTap() {
        playSound("button_click", ofType: "wav")
        
        isFrontCamera = !isFrontCamera
        print("IS FRONT CAMERA: \(isFrontCamera)")
        
        // Front Camera
        if isFrontCamera {
            swicthScreenButton.setBackgroundImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera.fill"), for: .normal)
            
            // Disable flash
            if isFlashON {
                isFlashON = false
                flashButton.setBackgroundImage(UIImage(named: "cam_flash_off"), for: .normal)
                do {
                    try camera.inputCamera.lockForConfiguration()
                    camera.inputCamera.torchMode = .off
                    camera.inputCamera.unlockForConfiguration()
                } catch { print("\(error)") }
            }
            
            resetCameraAndStartItAgain()
            
        // Back Camera
        } else {
            swicthScreenButton.setBackgroundImage(UIImage(systemName: "arrow.triangle.2.circlepath.camera"), for: .normal)
            resetCameraAndStartItAgain()
        }
    }
    
    func resetCameraAndStartItAgain() {
        do {
            sharedImageProcessingContext.runOperationAsynchronously {
                self.camera.stopCapture()
                self.camera.removeAllTargets()
                self.setCameraUIAndFilters()
            }
        }
    }
    // MARK: - Initializer
    
    // MARK: - LifeCycle
    override func viewDidLayoutSubviews() { layout() }
    override func viewDidAppear(_ animated: Bool) { attribute() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchEvent()
    }
    
    // MARK: - Actions
    
    func filterButtonDidTap() {
        do {
            sharedImageProcessingContext.runOperationSynchronously{
                camera.stopCapture()
                camera.removeAllTargets()
            }
            
            let filterListVC = FilterListViewController()
            filterListVC.modalPresentationStyle = .fullScreen
            present(filterListVC, animated: true, completion: nil)
        }
    }
    
    func shareListPhotoButtonDidTap() {
        if previewImg.image != nil {
//            playSound("button_click", ofType: "wav")
            do {
                sharedImageProcessingContext.runOperationSynchronously{
                    camera.stopCapture()
                    camera.removeAllTargets()
                }
                
                let vc = EditViewController()
                vc.theImgToShare = imgToShare
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
}
