////
////  MainViewController+Layout.swift
////  Today
////
////  Created by 박준하 on 2023/02/22.
////  Copyright © 2023 Goodjunha. All rights reserved.
////
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - Layout (View) Method
@available(iOS 13.0, *)
extension MainViewController {
    
    func iPhonelayout() {
        
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
