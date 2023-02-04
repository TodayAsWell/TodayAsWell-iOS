import UIKit
import Then
import SnapKit
import GPUImage
import RxSwift
import RxCocoa

@available(iOS 13.0, *)
class ViewController: BaseVC {
    
    private lazy var renderView = RenderView()
    private lazy var shootButton = UIButton()
    var camera:Camera!

    var isFrontCamera = false
    
    override func attribute() {
        setCameraUIAndFilters()
        
        shootButton.setBackgroundImage(UIImage(named: "cam_snap_butt_highlighted"), for: .highlighted)
        
        view.backgroundColor = .white
    }
    
    override func touchEvent() {
        shootButton.rx.tap
            .bind {
                self.shootButtonDidTap()
            }.disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(renderView)
        view.addSubview(shootButton)
        
        renderView.snp.makeConstraints {
            $0.height.width.equalTo(430.0)
            $0.centerX.centerY.equalToSuperview()
        }
        
        shootButton.snp.makeConstraints {
            $0.top.equalTo(renderView.snp.bottom).offset(51.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100.0)
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
}
