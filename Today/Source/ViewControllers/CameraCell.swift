//
//  CameraCell.swift
//  Today
//
//  Created by 박준하 on 2023/02/11.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit
import SnapKit
import Then

class CameraCell: UITableViewCell {
    
    static let identifier = "CameraTableViewCell"
    
    var camImg = UIImageView()
    var camNameLabel = UILabel()
    var camDescriptionLabel = UILabel().then {
        $0.numberOfLines = 2
    }
    var camSelectButton = UIButton()
    var proLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        camImg.backgroundColor = .red
        layout()
    }
    
    func layout() {
        [
            camImg,
            camNameLabel,
            camDescriptionLabel,
            camSelectButton,
            proLabel
        ].forEach { addSubview($0) }
        
        camImg.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10.0)
            $0.leading.equalToSuperview().offset(30.0)
        }
        
        camNameLabel.snp.makeConstraints {
            $0.top.equalTo(camImg.snp.top).offset(20.0)
            $0.leading.equalTo(camImg.snp.trailing).offset(10.0)
        }
        
        camDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(45)
            $0.leading.equalTo(camNameLabel.snp.leading)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
