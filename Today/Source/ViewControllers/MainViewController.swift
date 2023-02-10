import UIKit
import Then
import SnapKit
import GPUImage
import RxSwift
import RxCocoa
import AVFoundation


@available(iOS 13.0, *)
class MainViewController: BaseVC {
    
    private lazy var renderView = RenderView()
    private lazy var shootButton = UIButton()
    private lazy var flashButton = UIButton()
    private lazy var previewButton = UIButton()
    private var previewImg = UIImageView()
    var imgInFrame = UIImageView()
    private var whiteFadingImg = UIImageView()
    var viewWithFrame = UIView()
    var camNameLabel: UILabel!
    
    var camera:Camera!

    var imgToShare = UIImage()
    var isFlashON = false
    var isFrontCamera = false
    
    override func attribute() {
        setCameraUIAndFilters()
        
//        let camStrArray = listOfCameras[cameraInUse].components(separatedBy: "__")
//        camNameLabel.text = camStrArray[0]
        
        // Camera BKG color
        view.backgroundColor = cameraColors[cameraInUse]
        
        whiteFadingImg.layer.cornerRadius = previewImg.bounds.size.width/2
        whiteFadingImg.layer.borderColor = UIColor.black.cgColor
        whiteFadingImg.layer.borderWidth = 6
        
        previewImg.layer.cornerRadius = previewImg.bounds.size.width/2
        previewImg.layer.borderColor = UIColor.black.cgColor
        previewImg.layer.borderWidth = 6
        
        shootButton.backgroundColor = .red
        
        shootButton.setBackgroundImage(UIImage(named: "cam_snap_butt_highlighted"), for: .highlighted)
        
        view.backgroundColor = .white
        
        flashButton.backgroundColor = .blue
        imgInFrame.backgroundColor = .clear
        previewButton.backgroundColor = .clear
        
        viewWithFrame.frame.origin.y = view.frame.size.height
    }
    
    override func touchEvent() {
        shootButton.rx.tap
            .bind {
                self.shootPictureButtonDidTap()
            }.disposed(by: disposeBag)
        
        flashButton.rx.tap
            .bind {
                self.flashButtonDidTap()
            }.disposed(by: disposeBag)
        
        previewButton.rx.tap
            .bind {
                self.shareLstPhotoButt()
                print("previewButton 호출")
            }.disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(renderView)
        view.addSubview(shootButton)
        view.addSubview(flashButton)
        [previewImg, imgInFrame].forEach { view.addSubview($0) }
        view.addSubview(previewButton)
        
        renderView.snp.makeConstraints {
            $0.height.width.equalTo(430.0)
            $0.centerX.centerY.equalToSuperview()
        }
        
        shootButton.snp.makeConstraints {
            $0.top.equalTo(renderView.snp.bottom).offset(51.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100.0)
        }
        
        flashButton.snp.makeConstraints {
            $0.top.equalTo(renderView.snp.bottom).offset(71.0)
            $0.leading.equalToSuperview().offset(30.0)
            $0.width.height.equalTo(60.0)
        }
        
        previewImg.snp.makeConstraints {
            $0.top.equalTo(flashButton.snp.top)
            $0.trailing.equalToSuperview().inset(30.0)
            $0.width.height.equalTo(flashButton.snp.width)
        }
//
        imgInFrame.snp.makeConstraints {
            $0.top.equalTo(previewImg.snp.top)
            $0.trailing.equalTo(previewImg.snp.trailing)
            $0.width.height.equalTo(previewImg.snp.width)
        }

        previewButton.snp.makeConstraints {
            $0.top.equalTo(imgInFrame.snp.top)
            $0.trailing.equalTo(imgInFrame.snp.trailing)
            $0.width.height.equalTo(imgInFrame.snp.width)
        }
    }
    
    //필터를 사용할거 넣는 함수
    func setCameraUIAndFilters() {
        print("CAMERA IN USE: \(cameraInUse)")
        
        // 필터 사용 않하는 거 모음
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
            break
                
            default:break
                
            }
            
            camera.startCapture()
            
        } catch { fatalError("Could not initialize the Camera: \(error)") }
    }
    
    //후레시 버튼 클릭 했을 때
    func flashButtonDidTap() {
        if !isFrontCamera {
            playSound("flash", ofType: "wav")
            
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
    
    //
    func shootPictureButtonDidTap() {

        AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
        
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
            self.playSound("roll_picture", ofType: "wav")
            self.whiteFadingImg.alpha = 0
            
        }, completion: { (finished: Bool) in
            self.shootButton.isEnabled = true
        })
    }
    
//    func saveImageWithFrame() {
//        UIGraphicsBeginImageContextWithOptions(viewWithFrame.bounds.size, false, 0)
//        viewWithFrame.drawHierarchy(in: viewWithFrame.bounds, afterScreenUpdates: true)
//        imgToShare = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//
//        // Save photo into a custom folder in the Camera Roll
//        savePhoto(image: imgToShare, albumName: APP_NAME, completion: nil)
//    }
    
    
    func shareLstPhotoButt() {
        if previewImg.image != nil {
            playSound("button_click", ofType: "wav")
            do {
                sharedImageProcessingContext.runOperationSynchronously{
                    camera.stopCapture()
                    camera.removeAllTargets()
                }
                
                let vc = ImageViewController()
//                vc.theImgToShare = imgToShare
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
}