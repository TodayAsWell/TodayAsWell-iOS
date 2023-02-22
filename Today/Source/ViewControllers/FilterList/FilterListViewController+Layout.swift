//
//  FilterListViewController+Layout.swift
//  Today
//
//  Created by 박준하 on 2023/02/22.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - Layout (View) Method
@available(iOS 13.0, *)
extension FilterListViewController {
    
    func layout() {
        view.addSubview(FilterListTableView)
        
        FilterListTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func attribute() {
        proIAPmade = DEFAULTS.bool(forKey: "proIAPmade")
        print("PRO IAP MADE: \(proIAPmade)")
        
        navigationSettings()
    }
}
