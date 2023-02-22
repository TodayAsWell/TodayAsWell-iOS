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
    
    // MARK: - UIComponenets
    internal lazy var frameView = UIView()
    internal lazy var imageInFrame = UIImageView()
    internal lazy var photoFrameImage = UIImageView()
    
    internal lazy var captionTextView = UITextView().then {
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 14)
    }
    internal lazy var framesScrollView = UIScrollView()
    internal lazy var captionTextField = UITextField()
    
    internal lazy var writingButton = UIButton().then {
        let image = UIImage(named: "add_caption_butt")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    internal lazy var shareButton = UIButton().then {
        let image = UIImage(named: "share_butt")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    internal lazy var dismissButton = UIButton().then {
        $0.backgroundColor = .red
    }
    
    var theImgToShare = UIImage()
    
    // MARK: - FunctionFunctions
    
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
    
    // MARK: - Initializer
    
    // MARK: - LifeCycle
    override func viewLayoutMarginsDidChange() { layout() }
    override func viewDidAppear(_ animated: Bool) { attribute() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        touchEvent()
    }
    
    // MARK: - Actions
    @objc func chooseFrameButt(_ sender:UIButton) {
        photoFrameImage.image = UIImage(named: "photo_frame" + "\(sender.tag+1)" )
    }
    
    func dismissButtonDidTap() {
        self.dismiss(animated: true)
    }
}

@available(iOS 13.0, *)
extension EditViewController: UITextViewDelegate, UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        captionTextView.text = textField.text
        captionTextView.resignFirstResponder()
        return true
    }
    
}
