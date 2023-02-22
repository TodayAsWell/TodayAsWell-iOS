//
//  EditViewController.swift
//  Today
//
//  Created by 박준하 on 2023/02/22.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

@available(iOS 13.0, *)
class EditViewController: BaseVC {
    private lazy var frameView = UIView()
    private lazy var imageInFrame = UIImageView()
    private lazy var photoFrameImage = UIImageView()
    
    private lazy var captionTextView = UITextView().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    private lazy var framesScrollView = UIScrollView()
    private lazy var captionTextField = UITextField()
    
    private lazy var writingButton = UIButton().then {
        let image = UIImage(named: "add_caption_butt")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    private lazy var shareButton = UIButton().then {
        let image = UIImage(named: "share_butt")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    var theImgToShare = UIImage()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func attribute() {
        super.attribute()
        
        imageInFrame.image = takenImage
        frameView.backgroundColor = .white
        photoFrameImage.image = UIImage(named: "photo_frame1")
        captionTextView.isUserInteractionEnabled = true
        setFrameButtonsInScrollView()
        
    }
    
    override func touchEvent() {
        
        writingButton.rx.tap
            .bind {
                self.addCaptionButton()
            }.disposed(by: disposeBag)
        
        shareButton.rx.tap
            .bind {
                self.shareButtonDidTap()
            }.disposed(by: disposeBag)
    }
    
    func setFrameButtonsInScrollView() {
        var X:CGFloat = 10
        let Y:CGFloat = 0
        let W:CGFloat = 44
        let H:CGFloat = 60
        let G:CGFloat = 8
        var counter = 0
        
        for i in 0..<PHOTO_FRAMES_NUMBER {
            counter = i
            
            let buttons = UIButton(type: .custom)
            buttons.frame = CGRect(x: X, y: Y, width: W, height: H)
            buttons.tag = i
            buttons.setBackgroundImage(UIImage(named: "photo_frame\(i+1)"), for: .normal)
            buttons.addTarget(self, action: #selector(chooseFrameButt(_:)), for: .touchUpInside)
            
            X += W + G
            framesScrollView.addSubview(buttons)
        }
        
        framesScrollView.contentSize = CGSize(width: W * CGFloat(counter+3), height: H)
    }
    
    func addCaptionButton() {
        let toolbar = UIView(frame: CGRect(x: 0, y: view.frame.size.height+44, width: view.frame.size.width, height: 44))
        toolbar.backgroundColor = UIColor.clear
        
        captionTextField.frame = CGRect(x: 12, y: -12, width: toolbar.frame.size.width - 12, height: 44)
        captionTextField.delegate = self
        captionTextField.textAlignment = .center
        captionTextField.placeholder = "Type a caption"
        captionTextField.font = UIFont.systemFont(ofSize: 14)
        captionTextField.returnKeyType = .done
        captionTextField.clearButtonMode = .always
        
        toolbar.addSubview(captionTextField)
        
        captionTextView.inputAccessoryView = toolbar
        captionTextView.delegate = self
        
        captionTextView.becomeFirstResponder()
        captionTextField.becomeFirstResponder()
    }
    
    func shareButtonDidTap() {
        UIGraphicsBeginImageContextWithOptions(frameView.bounds.size, false, 0)
        frameView.drawHierarchy(in: frameView.bounds, afterScreenUpdates: true)
        let imgToShare = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Share
        let titleMessage  = "멋진 사진을 공유해보세요 \(APP_NAME)"
        let shareItems = [titleMessage, imgToShare] as [Any]
        
        let vc = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        vc.excludedActivityTypes = [.print, .postToWeibo, .copyToPasteboard, .addToReadingList, .postToVimeo]
        present(vc, animated: true, completion: nil)
    }
    
    override func layout() {
        super.layout()
        
        [
            frameView,
            photoFrameImage,
            imageInFrame,
            captionTextView,
            writingButton,
            shareButton,
            framesScrollView
        ].forEach { view.addSubview($0) }
        
        frameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.equalTo(420.0)
        }
        
        photoFrameImage.snp.makeConstraints {
            $0.top.equalTo(frameView.snp.top).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(230.0) // +3
            $0.height.equalTo(390.0) //-2
        }
        
        imageInFrame.snp.makeConstraints {
            $0.top.equalTo(photoFrameImage.snp.top).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(190.0)
            $0.height.equalTo(260.0)
        }
        
        captionTextView.snp.makeConstraints {
            $0.top.equalTo(imageInFrame.snp.bottom).offset(10.0)
            $0.centerX.equalTo(photoFrameImage.snp.centerX)
            $0.width.equalTo(190.0)
            $0.height.equalTo(35.0)
            
        }
        
        writingButton.snp.makeConstraints {
            $0.top.equalTo(frameView.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().offset(80.0)
            $0.width.height.equalTo(100.0)
        }
        
        shareButton.snp.makeConstraints {
            $0.top.equalTo(writingButton.snp.top)
            $0.trailing.equalToSuperview().inset(80.0)
            $0.width.height.equalTo(writingButton.snp.width)
        }
        
        framesScrollView.snp.makeConstraints {
            $0.top.equalTo(writingButton.snp.bottom).offset(10.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    
    @objc func chooseFrameButt(_ sender:UIButton) {
        photoFrameImage.image = UIImage(named: "photo_frame" + "\(sender.tag+1)" )
    }
}

@available(iOS 13.0, *)
extension EditViewController: UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        captionTextView.text = textField.text
        captionTextView.resignFirstResponder()
        return true
    }
    
}
