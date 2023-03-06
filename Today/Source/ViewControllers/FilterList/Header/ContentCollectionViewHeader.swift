//
//  ContentCollectionViewHeader.swift
//  Today
//
//  Created by 박준하 on 2023/03/05.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit

class ContentCollectionViewHeader: UICollectionReusableView {
    let sectionNameLabel = UILabel()
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            sectionNameLabel.font = .systemFont(ofSize: 17.0, weight: .bold)
        }
        sectionNameLabel.textColor = .black
        sectionNameLabel.sizeToFit()
        
        addSubview(sectionNameLabel)
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
}
