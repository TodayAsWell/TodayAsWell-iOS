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
                //일반 필터
                camera --> renderView
            case 1:
                
                //블루 오션 필터
                whiteBalanceFlt.temperature = 4000
                camera --> saturationFlt --> whiteBalanceFlt --> renderView
                
            case 2:
                //실패작소녀 필터
                camera --> saturationFlt --> falseColorFlt --> renderView
                
            case 3:
                //슈렉 필터
                camera --> saturationFlt --> hueFlt --> renderView
                
            case 4:
                // 그것이 알고 싶다 필터
                camera --> saturationFlt --> pixelllateFlt --> renderView
            
            case 5:
                camera --> saturationFlt --> kuwaharaFlt --> renderView
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
    override func viewDidLayoutSubviews() { layout(); iPadLayout()}
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
            
//            let filterListVC = FilterListViewController()
//            filterListVC.modalPresentationStyle = .fullScreen
//            present(filterListVC, animated: true, completion: nil)
            let layout = UICollectionViewFlowLayout()
            let homelayoutVC = HomeViewController(collectionViewLayout: layout)
            homelayoutVC.modalPresentationStyle = .fullScreen
            present(homelayoutVC, animated: true)
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
    
    func layout() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            view.addSubview(renderView)
            view.addSubview(shootButton)
            [previewImg, imgInFrame].forEach { view.addSubview($0) }
            view.addSubview(previewButton)
            view.addSubview(filterButton)
            let stackView = UIStackView(arrangedSubviews: [ARButton, pendingButton, timerButton, flashButton, swicthScreenButton])
            stackView.axis = .horizontal
            stackView.spacing = 30
            view.addSubview(stackView)
            
            renderView.snp.makeConstraints {
                $0.height.equalTo(330.0)
                $0.width.equalTo(330.0)
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(165)
            }
                        
            [ARButton, pendingButton, timerButton, flashButton, swicthScreenButton].forEach { $0.snp.makeConstraints {
                $0.height.width.equalTo(40.0)
            }}
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(renderView.snp.bottom).offset(20.0)
                $0.centerX.equalToSuperview()
            }
            
            
            shootButton.snp.makeConstraints {
                $0.top.equalTo(timerButton.snp.bottom).offset(20.0)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(100.0)
            }
            
            previewImg.snp.makeConstraints {
                $0.centerY.equalTo(shootButton.snp.centerY)
                $0.leading.equalToSuperview().offset(30.0)
                $0.width.height.equalTo(60.0)
            }
            
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
            
            filterButton.snp.makeConstraints {
                $0.top.equalTo(previewImg.snp.top)
                $0.trailing.equalToSuperview().inset(30.0)
                $0.width.height.equalTo(previewImg.snp.width)
            }
        }
    }
    
    func iPadLayout() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            view.addSubview(renderView)
            view.addSubview(shootButton)
            [previewImg, imgInFrame].forEach { view.addSubview($0) }
            view.addSubview(previewButton)
            view.addSubview(filterButton)
            let stackView = UIStackView(arrangedSubviews: [ARButton, pendingButton, timerButton, flashButton, swicthScreenButton])
            stackView.axis = .horizontal
            stackView.spacing = 100
            view.addSubview(stackView)
            
            renderView.snp.makeConstraints {
                $0.height.equalTo(660)
                $0.width.equalTo(660.0)
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(165)
            }
                        
            [ARButton, pendingButton, timerButton, flashButton, swicthScreenButton].forEach { $0.snp.makeConstraints {
                $0.height.width.equalTo(50.0)
            }}
            
            stackView.snp.makeConstraints {
                $0.top.equalTo(renderView.snp.bottom).offset(50.0)
                $0.centerX.equalToSuperview()
            }
            
            
            shootButton.snp.makeConstraints {
                $0.top.equalTo(timerButton.snp.bottom).offset(20.0)
                $0.centerX.equalToSuperview()
                $0.width.height.equalTo(120.0)
            }
            
            previewImg.snp.makeConstraints {
                $0.centerY.equalTo(shootButton.snp.centerY)
                $0.leading.equalToSuperview().offset(30.0)
                $0.width.height.equalTo(80.0)
            }

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
            
            filterButton.snp.makeConstraints {
                $0.top.equalTo(previewImg.snp.top)
                $0.trailing.equalToSuperview().inset(30.0)
                $0.width.height.equalTo(previewImg.snp.width)
            }
        }
            
    }
    
    func attribute() {
        setCameraUIAndFilters()
        
        whiteFadingImg.layer.cornerRadius = previewImg.bounds.size.width/2
        whiteFadingImg.layer.borderColor = UIColor.black.cgColor
        whiteFadingImg.layer.borderWidth = 6
        
        previewImg.layer.cornerRadius = previewImg.bounds.size.width/2
        previewImg.layer.borderColor = UIColor.black.cgColor
        previewImg.layer.borderWidth = 6
        
        imgInFrame.backgroundColor = .clear
        previewButton.backgroundColor = .clear
        
        viewWithFrame.frame.origin.y = view.frame.size.height
    }
    
    func touchEvent() {
        
        view.backgroundColor = .black
        
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
                self.shareListPhotoButtonDidTap()
                print("previewButton 호출")
            }.disposed(by: disposeBag)
        
        filterButton.rx.tap
            .bind {
                self.filterButtonDidTap()
                print("filterButton 클릭됨")
            }.disposed(by: disposeBag)
        
        ARButton.rx.tap
            .bind {
                print("ARButton tap")
            }.disposed(by: disposeBag)
        
        pendingButton.rx.tap
            .bind {
                print("pendingButton tap")
            }.disposed(by: disposeBag)
        
        timerButton.rx.tap
            .bind {
                print("timerButton tap")
            }.disposed(by: disposeBag)
        
        flashButton.rx.tap
            .bind {
                print("flashButton tap")
            }.disposed(by: disposeBag)
        
        swicthScreenButton.rx.tap
            .bind {
                self.swicthScreenButtonDidTap()
                print("screenTransitionButton tap")
            }.disposed(by: disposeBag)
    }
}
