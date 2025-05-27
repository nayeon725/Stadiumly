//
//  MainInfoViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/26/25.
//

import UIKit
import SnapKit

class MainInfoViewController: UIViewController {
    
    let foodImages = ["크새", "fries"]
    
    var timer: Timer?
    
    let titleImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "STADIUMLY_short"))
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let pitcherTitle: UILabel = {
        let label = UILabel()
        label.text = "오늘의 선발 투수"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let foodTitle: UILabel = {
        let label = UILabel()
        label.text = "먹거리 검색"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let weatherTitle: UILabel = {
        let label = UILabel()
        label.text = "날씨 정보"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private lazy var carouselView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0 // 셀 간의 가로 간격 - 셀들이 옆으로 나란히 있을 때의 간격
        layout.minimumLineSpacing = 0 // 수직 스크롤 시 간격
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout) // frame .zero >> 처음 크기 0,0
        collectionView.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 사용하겟삼
        collectionView.isPagingEnabled = true // 페이징 기능 on
        collectionView.showsHorizontalScrollIndicator = false // 스크롤바 숨김
        return collectionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // 로고 이미지
        view.addSubview(titleImage)
        if let image = UIImage(named: "STADIUMLY_short") {
            let imageRatio = image.size.height / image.size.width
            
            titleImage.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
                make.height.equalTo(titleImage.snp.width).multipliedBy(imageRatio)
            }
        }
        
        // 오늘의 선발 투수 타이틀
        view.addSubview(pitcherTitle)
        pitcherTitle.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        // 선발 투수 스택뷰 설정
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 0
        view.addSubview(horizontalStackView)
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(pitcherTitle.snp.bottom).offset(15)
            make.left.equalTo(pitcherTitle.snp.left)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }
        horizontalStackView.backgroundColor = .systemGray6
        
        let awayPitcher = createItemView(imageName: "pitcher_ohwonseok.png", pitcherName: "오원석", pitcherERA: 2.54)
        horizontalStackView.addArrangedSubview(awayPitcher)
        
        let vsLabel = UILabel()
        vsLabel.text = "VS"
        vsLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        vsLabel.textAlignment = .center
        horizontalStackView.addArrangedSubview(vsLabel)
        
        let homePitcher = createItemView(imageName: "pitcher_kimyoonha.png", pitcherName: "김윤하", pitcherERA: 7.23)
        horizontalStackView.addArrangedSubview(homePitcher)
        
        let itemWidth = (UIScreen.main.bounds.width - 40) / 3
        [awayPitcher, vsLabel, homePitcher].forEach { item in
            item.snp.makeConstraints { make in
                make.width.equalTo(itemWidth)
            }
        }
        
        // 먹거리 검색 타이틀
        view.addSubview(foodTitle)
        foodTitle.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(30)
            make.leading.equalTo(horizontalStackView.snp.leading)
        }
        
        // 먹거리 검색 컬렉션 뷰
        view.addSubview(carouselView)
        carouselView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: FoodCollectionCell.identifier)
        carouselView.dataSource = self
        carouselView.delegate = self
        
        activateTimer()
        
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(foodTitle.snp.bottom).offset(5)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(200)
        }
        
        // 날씨 정보 타이틀
        view.addSubview(weatherTitle)
        weatherTitle.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(20)
            make.leading.equalTo(horizontalStackView.snp.leading)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        titleImage.addGestureRecognizer(tapGesture)
    }
    
    @objc func logoTapped() {
        // 화면 전환 동작 (예: pull)
        navigationController?.popViewController(animated: true)
    }
    
    // 스택에 아이템 만들
    private func createItemView(imageName: String, pitcherName: String, pitcherERA: Double) -> UIView {
        let container = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.text = pitcherName
        
        let eraLabel = UILabel()
        eraLabel.font = .systemFont(ofSize: 20, weight: .regular)
        eraLabel.textAlignment = .center
        eraLabel.text = String(pitcherERA)
        
        let verticalStack = UIStackView(arrangedSubviews: [imageView, nameLabel, eraLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .fill
        verticalStack.distribution = .equalCentering
        
        container.addSubview(verticalStack)
        
        verticalStack.setCustomSpacing(10, after: imageView)
        verticalStack.setCustomSpacing(5, after: nameLabel)
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
        }
        
        return container
    }
}

extension MainInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("items.count = \(foodImages.count)")
        return foodImages.count * 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAt called for \(indexPath)")

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionCell.identifier, for: indexPath) as? FoodCollectionCell {
            let imageName = foodImages[indexPath.item % foodImages.count]
            cell.imageView.image = UIImage(named: imageName)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height = width * (2/3)
        
        return CGSize(width: width, height: height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        carouselView.reloadData()
        DispatchQueue.main.async {
            let startIndex = (self.foodImages.count * 1000) / 2
            self.carouselView.scrollToItem(at: IndexPath(item: startIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(carouselView.contentOffset.x / carouselView.frame.size.width)
        let numberOfItems = carouselView.numberOfItems(inSection: 0)

        let middle = numberOfItems / 2
        let imageCount = foodImages.count

        // 너무 앞 or 뒤로 간 경우 → 중간 위치로 자연스럽게 이동 (살짝 딜레이 줌)
        if currentIndex < imageCount || currentIndex > numberOfItems - imageCount {
            let newIndex = middle - middle % imageCount
            let newOffset = CGFloat(newIndex) * carouselView.frame.size.width
            
            // ★ 0.02초 뒤에 offset 이동: 부자연스럽게 튀는 현상 방지
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                self.carouselView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
            }
        }
    }

    private func visibleCellIndexpath() -> IndexPath {
        return carouselView.indexPathsForVisibleItems.first ?? IndexPath(item: 0, section: 0)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func activateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(moveToNextImage), userInfo: nil, repeats: true)
    }
    
    @objc private func moveToNextImage() {
        guard let currentIndexPath = carouselView.indexPathsForVisibleItems.first else { return }
        
        let numberOfItems = carouselView.numberOfItems(inSection: 0)
        let imageCount = foodImages.count
        let middle = numberOfItems / 2
        
        var nextItem = currentIndexPath.item + 1
        
        if nextItem < imageCount || nextItem > numberOfItems - imageCount {
            nextItem = middle - middle % imageCount + (nextItem % imageCount)
            let newOffset = CGFloat(nextItem) * carouselView.frame.size.width
            carouselView.setContentOffset(CGPoint(x: newOffset, y: 0), animated: false)
            nextItem += 1
            if nextItem >= numberOfItems {
                nextItem = 0
            }
        }

        carouselView.scrollToItem(at: IndexPath(item: nextItem, section: 0), at: .centeredHorizontally, animated: true)
    }
}
