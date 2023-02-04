//
//  ViewController.swift
//  Today
//
//  Created by 박준하 on 2023/02/04.
//  Copyright © 2023 XScoder. All rights reserved.
//

import UIKit
import Then
import SnapKit
import GPUImage

class ViewController: UIViewController {
    
    private lazy var renderView = RenderView()
    var camera:Camera!
    
//    private lazy var comeingSoon = UILabel().then {
//        $0.font = .systemFont(ofSize: 24.0, weight: .bold)
//        $0.text = "곧 돌아오겠습니다"
//        $0.textColor = .black
//    }
    
    var imgToShare = UIImage()
    var isFlashON = false
    var isFrontCamera = false
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setCameraUIAndFilters()
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
        renderView.snp.makeConstraints {
            $0.height.equalToSuperview()
            $0.width.equalToSuperview()
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
