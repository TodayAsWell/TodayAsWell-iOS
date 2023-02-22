import UIKit

import RxSwift
import RxCocoa
import RxRelay
import RxFlow

import Then
import SnapKit

import Moya
import Alamofire
import Kingfisher

@available(iOS 13.0, *)
class BaseVC: UIViewController {
    let bound = UIScreen.main.bounds
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.bind()
        self.configure()
        self.view.setNeedsUpdateConstraints()
    }
    func configure() { }
    func bind() { }
}

