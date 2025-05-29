//
//  CarouselTestView.swift
//  Stadiumly
//
//  Created by 김나연 on 5/29/25.
//
//
//  MainInfoViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/26/25.
//

import UIKit
import SnapKit

class CarouselViewTestViewController: UIViewController {
    
    let foodImages = ["111", "222","333","444"]
    private var timer: Timer?
    private var currentIndex: Int = 0 {
        didSet {
            // currentIndex가 음수가 되지 않도록 보장
            if currentIndex < 0 {
                currentIndex = foodImages.count - 1
            }
            // currentIndex가 배열 범위를 벗어나지 않도록 보장
            currentIndex = currentIndex % foodImages.count
        }
    }
    
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
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = foodImages.count
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .gray
        return pageControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        startAutoScroll()
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
        setupCarouselView()
        
        // 날씨뷰는 pageControl 아래에 위치
        view.addSubview(weatherTitle)
        weatherTitle.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(20)
            make.leading.equalTo(foodTitle.snp.leading)
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
    
    private func setupCarouselView() {
        // 먹거리 검색 컬렉션 뷰
        view.addSubview(carouselView)
        view.addSubview(pageControl)
        
        carouselView.register(CarouselCell.self, forCellWithReuseIdentifier: "CarouselCell")
        carouselView.dataSource = self
        carouselView.delegate = self
        
        // carouselView는 foodTitle 아래에 위치
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(foodTitle.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        // pageControl은 carouselView 아래에 위치
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        // 초기 위치 설정
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.carouselView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
            self.startAutoScroll()
        }
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
//        guard let currentIndexPath = carouselView.indexPathsForVisibleItems.first else { return }
        let nextItem = 2 // 항상 다음 페이지로 이동
        let nextIndexPath = IndexPath(item: nextItem, section: 0)
        
        carouselView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        
        // 스크롤이 끝나면 자동으로 중앙으로 리셋
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.currentIndex = (self?.currentIndex ?? 0 + 1) % (self?.foodImages.count ?? 1)
            self?.resetCarouselPosition()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
}

// MARK: - UICollectionViewCell
class CarouselCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with imageName: String) {
        imageView.image = UIImage(named: imageName)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension CarouselViewTestViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodImages.count * 3 // 3개의 섹션만 사용 (이전, 현재, 다음)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCell
        let imageIndex = (indexPath.item + currentIndex) % foodImages.count
        cell.configure(with: foodImages[imageIndex])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let imageIndex = (page + currentIndex) % foodImages.count
        pageControl.currentPage = imageIndex
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
        if page == 0 {
            // 첫 번째 페이지에서 왼쪽으로 스크롤
            currentIndex = (currentIndex - 1 + foodImages.count) % foodImages.count
            resetCarouselPosition()
        } else if page == 2 {
            // 마지막 페이지에서 오른쪽으로 스크롤
            currentIndex = (currentIndex + 1) % foodImages.count
            resetCarouselPosition()
        }
    }
    
    private func resetCarouselPosition() {
        // 중앙 페이지로 즉시 이동
        carouselView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
}
