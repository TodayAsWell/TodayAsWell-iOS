//
//  ViewController.swift
//  Today
//
//  Created by 박준하 on 2023/03/06.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = "Hello, World!"
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        label.textColor = .red
        label.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        
        // 아이패드에서는 더 큰 폰트 크기와 다른 위치에 표시
        if UIDevice.current.userInterfaceIdiom == .pad {
            label.font = UIFont.systemFont(ofSize: 60)
            label.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 4)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
