import UIKit
import Then
import SnapKit
import GPUImage
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private lazy var renderView = RenderView()
    private lazy var shootButton = UIButton()
    var camera:Camera!

    var isFrontCamera = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setCameraUIAndFilters()
        
        shootButton.setBackgroundImage(UIImage(named: "cam_snap_butt_highlighted"), for: .highlighted)
    }
    
    
      // ------------------------------------------------
      // MARK: - SET CAMERA & FILTERS
      // ------------------------------------------------
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

          
          // Initialize Camera
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
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
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
        
        shootButton.rx.tap
            .bind {
                self.shootButtonDidTap()
            }
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
