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
    
    var lat: Double = 37.496659317
    var lon: Double = 126.866788407
    let appid: String = "2692e89765ccfba179e8f09fc3810664"
    var imgData: Data?
    var rcText: String = ""
    var stadiumName: String = "고척스카이돔"
    var temp: Double = 0.0
    
    let titleImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "STADIUMLY_short"))
        image.contentMode = .scaleAspectFit
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let pitcherTitle: UILabel = {
        let label = UILabel()
        label.text = "⚾️ 오늘의 선발 투수"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let foodTitle: UILabel = {
        let label = UILabel()
        label.text = "🔍 먹거리 검색"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let weatherTitle: UILabel = {
        let label = UILabel()
        label.text = "☀️ 날씨 정보"
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
    
    let pitcherStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.backgroundColor = .systemGray6
        stack.distribution = .equalCentering
        stack.layer.cornerRadius = 12
        stack.layer.shadowColor = UIColor.black.cgColor
        stack.layer.shadowOpacity = 0.1
        stack.layer.shadowOffset = CGSize(width: 0, height: 2)
        stack.layer.shadowRadius = 4
        stack.clipsToBounds = false
        return stack
    }()
    
    let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
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
        setupPitcherUI()
        
        // 먹거리 검색 부분
        setupCarouselView()
        
        // 날씨 정보 부분
        setupWeatherUI()
        
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
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        container.clipsToBounds = false

        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit

        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textAlignment = .center
        nameLabel.text = pitcherName

        let eraLabel = UILabel()
        eraLabel.font = .systemFont(ofSize: 16, weight: .regular)
        eraLabel.textAlignment = .center
        eraLabel.textColor = .darkGray
        eraLabel.text = "ERA: \(pitcherERA)"

        let verticalStack = UIStackView(arrangedSubviews: [imageView, nameLabel, eraLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 8

        container.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }

        imageView.snp.makeConstraints { make in
            make.height.equalTo(80)
            make.width.equalTo(80)
        }

        return container
    }

    
    // 날씨 스택 아이템
    private func createWeatherItem(stadiumName: String, temp: Double) -> UIView {
        let container = UIView()
        
        let nameLabel = UILabel()
        nameLabel.text = stadiumName
        nameLabel.font = .systemFont(ofSize: 25, weight: .bold)
        nameLabel.textAlignment = .left
        nameLabel.textColor = .label
        
        let tempLabel = UILabel()
        tempLabel.text = "현재 온도: \(temp)"
        tempLabel.font = .systemFont(ofSize: 20, weight: .medium)
        tempLabel.textAlignment = .left
        tempLabel.textColor = .systemBlue
        
        let verticalStack = UIStackView(arrangedSubviews: [nameLabel, tempLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.distribution = .equalCentering
        verticalStack.spacing = 8
        
        container.addSubview(verticalStack)
        
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return container
    }
    
    private func setupCarouselView() {
        view.addSubview(foodTitle)
        foodTitle.snp.makeConstraints { make in
            make.top.equalTo(pitcherStackView.snp.bottom).offset(20)
            make.leading.equalTo(pitcherStackView.snp.leading)
        }
        
        // 먹거리 검색 컬렉션 뷰
        view.addSubview(carouselView)
        carouselView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: "FoodCollection")
        carouselView.dataSource = self
        carouselView.delegate = self
        
        // carouselView는 foodTitle 아래에 위치
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(foodTitle.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
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
        view.addSubview(pitcherTitle)
        pitcherTitle.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }

        view.addSubview(pitcherStackView)
        pitcherStackView.snp.makeConstraints { make in
            make.top.equalTo(pitcherTitle.snp.bottom).offset(10)
            make.left.equalTo(pitcherTitle.snp.left)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }

        pitcherStackView.axis = .horizontal
        pitcherStackView.spacing = 0
        pitcherStackView.distribution = .fillEqually
        pitcherStackView.alignment = .center
        pitcherStackView.backgroundColor = .clear

        let awayPitcher = createPitcherItem(imageName: "pitcher_ohwonseok.png", pitcherName: "오원석", pitcherERA: 2.54)
        let vsLabel = UILabel()
        vsLabel.text = "VS"
        vsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        vsLabel.textAlignment = .center
        vsLabel.textColor = .darkGray

        let homePitcher = createPitcherItem(imageName: "pitcher_kimyoonha.png", pitcherName: "김윤하", pitcherERA: 7.23)

        pitcherStackView.addArrangedSubview(awayPitcher)
        pitcherStackView.addArrangedSubview(vsLabel)
        pitcherStackView.addArrangedSubview(homePitcher)

        // VS 라벨 비율 조정
        vsLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
    }

    
    private func setupWeatherUI() {
        // 1. weatherTitle
        view.addSubview(weatherTitle)
        weatherTitle.snp.makeConstraints { make in
            make.top.equalTo(carouselView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }

        // 2. 날씨 카드 뷰
        let weatherCardView = UIView()
        weatherCardView.backgroundColor = .white
        weatherCardView.layer.cornerRadius = 16
        weatherCardView.layer.shadowColor = UIColor.black.cgColor
        weatherCardView.layer.shadowOpacity = 0.08
        weatherCardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        weatherCardView.layer.shadowRadius = 6
        view.addSubview(weatherCardView)

        weatherCardView.snp.makeConstraints { make in
            make.top.equalTo(weatherTitle.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(140)
        }

        // 3. 아이콘
        let weatherImage = UIImageView()
        if let imgData, let img = UIImage(data: imgData) {
            weatherImage.image = img
        }
        weatherImage.contentMode = .scaleAspectFit
        weatherImage.snp.makeConstraints { make in
            make.size.equalTo(80)
        }

        // 4. 온도/구장명 텍스트
        let infoStack = createWeatherItem(stadiumName: stadiumName, temp: temp)

        // 5. 상단 스택 구성
        let topStack = UIStackView(arrangedSubviews: [weatherImage, infoStack])
        topStack.axis = .horizontal
        topStack.alignment = .center
        topStack.spacing = 15
        weatherCardView.addSubview(topStack)

        topStack.snp.makeConstraints { make in
            make.top.equalTo(weatherCardView.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }

        // 6. 우천 취소 안내 (텍스트만 예쁘게)
        let rainLabel = UILabel()
        rainLabel.text = rcText
        rainLabel.font = .systemFont(ofSize: 16, weight: .medium)
        rainLabel.numberOfLines = 2

        weatherCardView.addSubview(rainLabel)

        rainLabel.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(weatherCardView.snp.bottom).inset(15)
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
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self,
                  let data else {
                // alert 처리
                print("데이터 정보를 가져올 수 없습니다.")
                return
            }
            
            do {
                let root = try JSONDecoder().decode(WeatherRoot.self, from: data)
                let weather = root.weather
                let rain = root.rain
                let main = root.main
                
                guard let weatherIcon = weather.first?.icon else { return }
                
                // 메인 스레드에서 온도 업데이트
                DispatchQueue.main.async {
                    self.temp = main.temp
                }
                
                // 우천 취소 텍스트 설정
                let rainText = (rain?.oneHour ?? 0 >= 10.0) ?
                    "우천 취소 확률이 있습니다. 관람에 유의하세요. ☔️" :
                    "우천 취소 확률이 없습니다. 즐겁게 관람하세요 ☀️"
                
                // 이미지 데이터 가져오기
                if let imageURL = URL(string: "https://openweathermap.org/img/wn/\(weatherIcon).png") {
                    let request = URLRequest(url: imageURL)
                    
                    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                        guard let self = self,
                              let imageData = data else { return }
                        
                        // 메인 스레드에서 이미지 데이터와 텍스트 업데이트 후 UI 새로고침
                        DispatchQueue.main.async {
                            self.imgData = imageData
                            self.rcText = rainText
                            
                            // UI 업데이트를 위해 setupWeatherUI 다시 호출
                            self.setupWeatherUI()
                        }
                    }.resume()
                }
                
            } catch {
                // alert 처리
                print("JSON 디코딩 실패: \(error.localizedDescription)")
            }
        }.resume()
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
