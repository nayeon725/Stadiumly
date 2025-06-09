import UIKit
import SnapKit

class SplashViewController: UIViewController {
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stadiumlyLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(100)
        }
    }
} 