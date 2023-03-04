//
//  ProductCollectionViewCell.swift
//  Today
//
//  Created by 박준하 on 2023/03/04.
//  Copyright © 2023 Goodjunha. All rights reserved.
//

import UIKit

class Product {
    var image: UIImage?
    var name: String
    var price: Int
    var description: String
    
    init(image: UIImage?, name: String, price: Int, description: String) {
        self.image = image
        self.name = name
        self.price = price
        self.description = description
    }
}

class ProductCollectionViewCell: UICollectionViewCell {
    let imageView = UIImageView()
    let priceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀 UI 구성
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(priceLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            priceLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProductListViewController: UIViewController {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        products = [
            Product(image: UIImage(named: "product1"), name: "Product 1", price: 10000, description: "This is product 1."),
            Product(image: UIImage(named: "product2"), name: "Product 2", price: 20000, description: "This is product 2."),
            Product(image: UIImage(named: "product3"), name: "Product 3", price: 30000, description: "This is product 3."),
            Product(image: UIImage(named: "product4"), name: "Product 4", price: 40000, description: "This is product 4."),
            Product(image: UIImage(named: "product5"), name: "Product 5", price: 50000, description: "This is product 5.")
        ]
        
        // 컬렉션뷰 UI 구성
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "productCell")
    }
}

extension ProductListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        let product = products[indexPath.row]
        
        // 셀 데이터 설정
        cell.imageView.image = product.image
        cell.priceLabel.text = "\(product.price)원"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2 - 8
        return CGSize(width: cellWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.present(ProductDetailViewController(), animated: true)
    }
}

class ProductDetailViewController: UIViewController {
    let scrollView = UIScrollView()
    let imageView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let descriptionLabel = UILabel()
    let quantityLabel = UILabel()
    let quantityStepper = UIStepper()
    let addToCartButton = UIButton()
    var product: Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 스크롤뷰 UI 구성
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityStepper.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(quantityLabel)
        scrollView.addSubview(quantityStepper)
        scrollView.addSubview(addToCartButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            
            quantityLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            quantityLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            quantityStepper.centerYAnchor.constraint(equalTo: quantityLabel.centerYAnchor),
            quantityStepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: 8),
            
            addToCartButton.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 32),
            addToCartButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            addToCartButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            addToCartButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        addToCartButton.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        // 제품 데이터 설정
        guard let product = product else { return }
        imageView.image = product.image
        nameLabel.text = product.name
        priceLabel.text = "\(product.price)원"
        descriptionLabel.text = product.description
    }
    
    @objc func addToCart() {
        // 장바구니에 제품 추가
    }
}
