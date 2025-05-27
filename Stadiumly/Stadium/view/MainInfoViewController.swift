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
    var isInnititialScrollDone = false
    
    var lat: Double = 37.496659317
    var lon: Double = 126.866788407
    let appid: String = "2692e89765ccfba179e8f09fc3810664"
    
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
    
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        searchWeather()
        
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
        
        // 오늘의 선발 투수 부분
        view.addSubview(pitcherTitle)
        pitcherTitle.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        setupPitcherUI()
        
        // 먹거리 검색 부분
        view.addSubview(foodTitle)
        foodTitle.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(30)
            make.leading.equalTo(horizontalStackView.snp.leading)
        }
        setupCarouselView()
        
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
    
    // 선발투수 스택 아이템
    private func createPitcherItem(imageName: String, pitcherName: String, pitcherERA: Double) -> UIView {
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
    
    // 날씨 스택 아이템
    private func createWeatherItem(imageName: String, pitcherName: String, pitcherERA: Double) -> UIView {
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
        
        carouselView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: "FoodCollection")
        carouselView.dataSource = self
        carouselView.delegate = self
        
        // carouselView는 foodTitle 아래에 위치
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(foodTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        // 초기 위치 설정
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let middleIndex = self.foodImages.count * 100
            self.carouselView.scrollToItem(at: IndexPath(item: middleIndex, section: 0), at: .centeredHorizontally, animated: false)
            self.startAutoScroll()
        }
    }
    
    private func setupPitcherUI() {
        // 오늘의 선발 투수 스택뷰
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(pitcherTitle.snp.bottom).offset(15)
            make.left.equalTo(pitcherTitle.snp.left)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(160)
        }
        horizontalStackView.backgroundColor = .systemGray6
        
        let awayPitcher = createPitcherItem(imageName: "pitcher_ohwonseok.png", pitcherName: "오원석", pitcherERA: 2.54)
        horizontalStackView.addArrangedSubview(awayPitcher)
        
        let vsLabel = UILabel()
        vsLabel.text = "VS"
        vsLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        vsLabel.textAlignment = .center
        horizontalStackView.addArrangedSubview(vsLabel)
        
        let homePitcher = createPitcherItem(imageName: "pitcher_kimyoonha.png", pitcherName: "김윤하", pitcherERA: 7.23)
        horizontalStackView.addArrangedSubview(homePitcher)
        
        let itemWidth = (UIScreen.main.bounds.width - 40) / 3
        [awayPitcher, vsLabel, homePitcher].forEach { item in
            item.snp.makeConstraints { make in
                make.width.equalTo(itemWidth)
            }
        }
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
        guard let currentIndexPath = carouselView.indexPathsForVisibleItems.first else { return }
        let nextItem = currentIndexPath.item + 1
        let nextIndexPath = IndexPath(item: nextItem, section: 0)
        
        carouselView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    func searchWeather() {
        let endPt = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(appid)&units=metric&lang=kr"
        guard let url = URL(string: endPt) else { return }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                // alert 처리f
                fatalError("데이터 정보를 가져올 수 없습니다.")
            }
            
            do {
                let root = try JSONDecoder().decode(WeatherRoot.self, from: data)
                let weather = root.weather
                let rain = root.rain
                let main = root.main
                
                if let rain = rain, rain.oneHour >= 10.0 {
                    // 우천 취소 oo
                } else {
                    // 우천 취소 xx
                }
                
            } catch {
                // alert 처리
                print("JSON 디코딩 실패: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension MainInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodImages.count * 200 // 충분히 큰 수로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionCell.identifier, for: indexPath) as! FoodCollectionCell
        let imageIndex = indexPath.item % foodImages.count
        cell.configure(with: foodImages[imageIndex])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let imageCount = foodImages.count
        
        // 경계에 도달했을 때 중간으로 이동
        if currentIndex < imageCount || currentIndex > (foodImages.count * 200) - imageCount {
            let middleIndex = foodImages.count * 100
            let newIndex = middleIndex + (currentIndex % imageCount)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newIndex) * scrollView.bounds.width, y: 0), animated: false)
        }
    }
}
