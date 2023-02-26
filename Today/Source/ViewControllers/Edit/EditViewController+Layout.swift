//
//  EditViewController+Layout.swift
//  Today
//
//  Created by 박준하 on 2023/02/22.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit
import SnapKit

// MARK: - Layout (View) Method
@available(iOS 13.0, *)
extension EditViewController {
    
    func layout() {
        [
            frameView,
            photoFrameImage,
            imageInFrame,
            captionTextView,
            writingButton,
            shareButton,
            framesScrollView,
            dismissButton
        ].forEach { view.addSubview($0) }
        
        let width = view.frame.width / 430
        let height = view.frame.height / 932
        
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
        
        dismissButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10.0)
            $0.leading.equalToSuperview().offset(30.0)
            $0.width.height.equalTo(40.0)
        }
    }
    
        func attribute() {
            imageInFrame.image = takenImage
            frameView.backgroundColor = .white
            photoFrameImage.image = UIImage(named: "photo_frame1")
            captionTextView.isUserInteractionEnabled = true
        }

        func touchEvent() {

            writingButton.rx.tap
                .bind {
                    self.addCaptionButton()
                }.disposed(by: disposeBag)

            shareButton.rx.tap
                .bind {
                    self.shareButtonDidTap()
                }.disposed(by: disposeBag)

            dismissButton.rx.tap
                .bind {
                    self.dismissButtonDidTap()
                }.disposed(by: disposeBag)
        }
}
