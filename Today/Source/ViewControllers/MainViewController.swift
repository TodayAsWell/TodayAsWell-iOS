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
    
    var camera:Camera!

    var isFlashON = false
    var isFrontCamera = false
    
    override func attribute() {
        setCameraUIAndFilters()
        
        shootButton.backgroundColor = .red
        
        shootButton.setBackgroundImage(UIImage(named: "cam_snap_butt_highlighted"), for: .highlighted)
        
        view.backgroundColor = .white
        
        flashButton.backgroundColor = .blue
    }
    
    override func touchEvent() {
        shootButton.rx.tap
            .bind {
                self.shootButtonDidTap()
            }.disposed(by: disposeBag)
        
        flashButton.rx.tap
            .bind {
                self.flashButtonDidTap()
            }.disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(renderView)
        view.addSubview(shootButton)
        view.addSubview(flashButton)
        
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
    }
    
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
    
    
    func shootButtonDidTap() {
        playSound("button_click", ofType: "wav")
        do {
            sharedImageProcessingContext.runOperationSynchronously{
                camera.stopCapture()
                camera.removeAllTargets()
            }
        }
    }
    
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
}
