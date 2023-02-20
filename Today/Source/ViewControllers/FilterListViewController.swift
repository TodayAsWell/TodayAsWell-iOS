//
//  FilterListViewController.swift
//  Today
//
//  Created by 박준하 on 2023/02/11.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

@available(iOS 13.0, *)
class FilterListViewController: BaseVC {
    
    private lazy var tableView = UITableView().then {
        $0.register(CameraCell.self, forCellReuseIdentifier: CameraCell.identifier)
        $0.delegate = self
        $0.dataSource = self
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func backButt(_ sender: Any) {
       dismiss(animated: true, completion: nil)
   }
}

@available(iOS 13.0, *)
extension FilterListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfCameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CameraCell.identifier, for: indexPath) as! CameraCell
        
        cell.camImg.image = UIImage(named: "cam\(indexPath.row+1)")
        cell.camImg.layer.cornerRadius = 6
        
        let camStrArray = listOfCameras[indexPath.row].components(separatedBy: "__")
        cell.camNameLabel.text = camStrArray[0]
        cell.camDescriptionLabel.text = camStrArray[0]
        
        if indexPath.row > 1 {
            if !proIAPmade { cell.proLabel.isHidden = false
            } else { cell.proLabel.isHidden = true }
        }
        cell.proLabel.layer.cornerRadius = 12
        
        cell.camSelectButton.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cameraInUse = indexPath.row
        dismiss(animated: true, completion: nil)
    }
}
