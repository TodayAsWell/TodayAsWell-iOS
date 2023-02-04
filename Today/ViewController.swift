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

class ViewController: UIViewController {
    
    private lazy var comeingSoon = UILabel().then {
        $0.font = .systemFont(ofSize: 24.0, weight: .bold)
        $0.text = "곧 돌아오겠습니다"
        $0.textColor = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(comeingSoon)
        comeingSoon.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
