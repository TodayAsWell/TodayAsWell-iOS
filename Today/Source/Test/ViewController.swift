//
//  ViewController.swift
//  Today
//
//  Created by 박준하 on 2023/03/05.
//  Copyright © 2023 Goodjunha. All rights reserved.
//
import UIKit
import SnapKit
import Then

class ViewController: UIViewController {
    
    let scrollView = UIScrollView().then {
        $0.isPagingEnabled = true
    }
    
    let pageControl = UIPageControl().then {
        $0.numberOfPages = 3
        $0.currentPage = 0
        $0.currentPageIndicatorTintColor = .black
        $0.pageIndicatorTintColor = .lightGray
    }
    
    var lastContentOffsetX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupPageControl()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        for i in 1...3 {
            let imageView = UIImageView(image: UIImage(named: "poster\(i)"))
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            
            imageView.snp.makeConstraints {
                $0.width.height.equalToSuperview()
                $0.top.equalToSuperview()
                $0.leading.equalTo((i - 1) * Int(view.frame.width))
            }
        }
        
        scrollView.contentSize = CGSize(width: Int(view.frame.width) * 3, height: Int(view.frame.height))
        scrollView.delegate = self
    }
    
    func setupPageControl() {
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let contentOffsetX = scrollView.contentOffset.x
        let currentPageFloat = (contentOffsetX + width * 0.5) / width
        var currentPage = Double(currentPageFloat)
        let progress = currentPageFloat - CGFloat(currentPage)
        
        // 현재 페이지에서 스크롤하는 방향에 따라 다음 페이지를 결정
        if scrollView.contentOffset.x > lastContentOffsetX {
            currentPage = min(currentPage + 1, pageControl.numberOfPages - 1)
        } else if scrollView.contentOffset.x < lastContentOffsetX {
            currentPage = max(currentPage - 1, 0)
        }
        
        // 현재 페이지에서 스크롤하는 방향에 따라 페이지 컨트롤러 업데이트
        if scrollView.isDragging {
            if scrollView.contentOffset.x > lastContentOffsetX && progress > 0.5 {
                pageControl.currentPage = currentPage + 1
            } else if scrollView.contentOffset.x < lastContentOffsetX && progress < 0.5 {
                pageControl.currentPage = currentPage
            } else {
                pageControl.currentPage = currentPage
            }
        } else {
            pageControl.currentPage = currentPage
        }
        
        lastContentOffsetX = scrollView.contentOffset.x
    }
}
