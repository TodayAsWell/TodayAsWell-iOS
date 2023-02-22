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

@available(iOS 13.0, *)
class EditViewController: BaseVC {
    private lazy var frameView = UIView()
    private lazy var imageInFrame = UIImageView()
    private lazy var photoFrameImage = UIImageView()
    private lazy var captionTxt = UITextView()
    private lazy var framesScrollView = UIScrollView()
    private lazy var captionTxtField = UITextField()
    
    private lazy var writingButton = UIButton().then {
        let image = UIImage(named: "add_caption_butt")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    private lazy var shareButton = UIButton().then {
        let image = UIImage(named: "share_butt")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    var theImgToShare = UIImage()
    
    override func attribute() {
        super.attribute()
        
        photoFrameImage.image = takenImage
        frameView.backgroundColor = .black
        photoFrameImage.image = UIImage(named: "photo_frame1")
        framesScrollView.backgroundColor = .red
    }
    
    
    override func layout() {
        super.layout()
        
        [
            frameView,
            photoFrameImage,
            imageInFrame,
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
}
