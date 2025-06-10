//
//  MainInfoViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/26/25.
//

import UIKit
import SnapKit
import SideMenu
import Kingfisher
import Alamofire

class MainInfoViewController: UIViewController {
    
    private var stadiumlyId: Int = 0
    private var foodImages: [String] = ["크새", "fries"]
    private var playerRecommand: [PlayerRecommand] = []
    private var timer: Timer?
    
    private var stadiums: [Stadium] = []
    private let endPt = "http://20.41.113.4/"
    
    // 타이틀 설정용 데이터
    private var teamName: String = ""
    // 날씨 서치용 데이터
    private var lat: Double = 37.496659317
    private var lon: Double = 126.866788407
    // 날씨 표시용 데이터
    private var stadiumName: String = ""
    private var imgURL: URL?
    private var rcText: String = ""
    private var temp: Double = 0.0
    // 사이드메뉴 설정 관련
    private let sideMenuWidth: CGFloat = 250
    private let sideMenuView = UIView()
    private var isSideMenuVisible = false
    // 선발투수 데이터용
    private var homePitcherName: String = ""
    private var homePitcherImage: URL?
    private var homeTeamName: String = ""
    private var awayPitcherName: String = ""
    private var awayPitcherImage: URL?
    private var awayTeamName: String = ""
    private var hasPitcherData: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.updatePitcherUI()
            }
        }
    }
    
    private enum DataSource {
        case playerRecommend
        case defaultFood
    }

    private var currentDataSource: DataSource = .playerRecommend
    
    private let pitcherTitle: UILabel = {
        let label = UILabel()
        label.text = "⚾️ 오늘의 선발 투수"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    private let foodTitle: UILabel = {
        let label = UILabel()
        label.text = "🔍 먹거리 검색"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    
    private let weatherTitle: UILabel = {
        let label = UILabel()
        label.text = "☀️ 날씨 정보"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .darkGray
        return label
    }()
    //캐러셀 참고
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
    
    private let pitcherStackView: UIStackView = {
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
    
    private let titleLabel = UILabel()
    
    private let weatherStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 0
        return stackView
    }()
    
    private lazy var openMenuButton: UIButton = {
        let openMenuButton = UIButton(type: .system)
        openMenuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        openMenuButton.tintColor = .label
        openMenuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        return openMenuButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTitle() // 타이틀 설정
        setupPitcherUI() // 오늘의 선발 투수 부분 ui
        updatePitcherUI()
        setupFoodList() // 먹거리 검색 부분 ui
        setupWeatherUI() // 날씨 정보 부분 ui
        // sidemenu
        setupSideMenu()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(logoTapped))
        titleLabel.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        updateStadiumInfo()
        updateUIAfterStadiumChange()
    }
    
    @objc func logoTapped() {
        // 화면 전환 동작 (예: pull)
        navigationController?.popViewController(animated: true)
    }
    
    private func updateUIAfterStadiumChange() {
        // 타이틀만 텍스트만 바꿔줌 (레이아웃 재설정 없이)
        titleLabel.text = teamName
        
        // 구장 정보 리셋
        findStadium()
        // 날씨 정보 새로 검색
        searchWeather()
    }
    
    private func updateStadiumInfo() {
        if let stadium = DataManager.shared.selectedStadium {
            stadiumlyId = stadium.id
            teamName = stadium.team
            stadiumName = stadium.name
            lat = stadium.latitude
            lon = stadium.longitude
            playerRecommed(stadiumlyId: "\(stadiumlyId)")
        }
    }
    
    private func findStadium() {
        print(teamName)
        let url = endPt + "/stadium/detail"
        
        let teamShort: String = teamName.components(separatedBy: " ").first ?? ""
        print("팀이름: \(teamName), 자른 팀 이름: \(teamShort)..")
        
        let parameters: [String: Any] = ["teamname": teamShort]
        
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: ["Content-Type": "application/json"])
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [PitcherRoot].self) { response in
            switch response.result {
            case .success(let decodedData):
//                print(decodedData.first)
                
                if let pitcherData = decodedData.first {
                    self.hasPitcherData = true
                    // 홈팀
                    self.homePitcherName = pitcherData.homePitcher
                    self.homeTeamName = pitcherData.homeTeam
                    self.homePitcherImage = URL(string: pitcherData.homeImg)
                    // 원정팀
                    self.awayPitcherName = pitcherData.awayPitcher
                    self.awayTeamName = pitcherData.awayTeam
                    self.awayPitcherImage = URL(string: pitcherData.awayImg)
                    // 날씨 이미지
                    self.imgURL = URL(string: pitcherData.weatherImage)
                    
                } else {
                    self.hasPitcherData = false
                }
                
                DispatchQueue.main.async {
                    self.updatePitcherUI()
                }
            case .failure(let error):
                print("네트워크 또는 디코딩 에러: \(error)")
                if let data = response.data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("받은 JSON 문자열: \(jsonString)")
                } else {
                    print("JSON 문자열 변환 실패")
                }
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(openMenuButton)
        openMenuButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            make.leading.equalToSuperview().offset(30)
        }
    }
    
    @objc private func openMenu() {
        if let menu = SideMenuManager.default.leftMenuNavigationController {
            present(menu, animated: true)
        }
    }
    
    private func setupSideMenu() {
        let menuVC = SideMenuViewController()
        let menu = SideMenuNavigationController(rootViewController: menuVC)
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        
        var settings = SideMenuSettings()
        settings.menuWidth = min(view.frame.width, view.frame.height) * 0.5
        menu.settings = settings
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
    }
    
    private func setupTitle() {
        // 네비게이션바에 타이틀
        titleLabel.text = teamName
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.isUserInteractionEnabled = true
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    // 선발투수 스택 아이템
    private func createPitcherItem(imageURL: URL, pitcherName: String, teamName: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.05
        container.layer.shadowOffset = CGSize(width: 0, height: 2)
        container.layer.shadowRadius = 4
        container.clipsToBounds = false
        
        let imageView = UIImageView()
        imageView.kf.setImage(with: imageURL)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 8
        imageView.layer.masksToBounds = false
        
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textAlignment = .center
        nameLabel.text = "선발 투수: \(pitcherName)"
        
        let teamLabel = UILabel()
        teamLabel.font = .systemFont(ofSize: 18, weight: .bold)
        teamLabel.textAlignment = .center
        teamLabel.textColor = .black
        teamLabel.text = teamName
        
        let verticalStack = UIStackView(arrangedSubviews: [teamLabel, imageView, nameLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .equalSpacing
        verticalStack.spacing = 10
        
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
    
    //캐러셀 참고
    private func setupFoodList() {
        view.addSubview(foodTitle)
        foodTitle.snp.makeConstraints { make in
            make.top.equalTo(pitcherStackView.snp.bottom).offset(20)
            make.leading.equalTo(pitcherStackView.snp.leading)
        }
        
        // 먹거리 검색 컬렉션 뷰
        view.addSubview(carouselView)
        carouselView.register(FoodCollectionCell.self, forCellWithReuseIdentifier: FoodCollectionCell.identifier)
        carouselView.dataSource = self
        carouselView.delegate = self
        
        // carouselView는 foodTitle 아래에 위치
        carouselView.snp.makeConstraints { make in
            make.top.equalTo(foodTitle.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
    }
    
    private func setupPitcherUI() {
        view.addSubview(pitcherTitle)
        pitcherTitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
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
        pitcherStackView.distribution = .equalSpacing
        pitcherStackView.alignment = .center
        pitcherStackView.backgroundColor = .clear
        
        guard let awayPitcherImage, let  homePitcherImage else { return }
        let awayPitcher = createPitcherItem(imageURL: homePitcherImage, pitcherName: homePitcherName, teamName: homeTeamName)
        
        let vsLabel = UILabel()
        vsLabel.text = "VS"
        vsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        vsLabel.textAlignment = .center
        vsLabel.textColor = .darkGray
        
        let homePitcher = createPitcherItem(imageURL: awayPitcherImage, pitcherName: awayPitcherName, teamName: awayTeamName)
        
        pitcherStackView.addArrangedSubview(awayPitcher)
        pitcherStackView.addArrangedSubview(vsLabel)
        pitcherStackView.addArrangedSubview(homePitcher)
        
        // VS 라벨 비율 조정
        vsLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
    }
    
    private func updatePitcherUI() {
        // 기존에 있던 stackView 안 뷰들 모두 제거
        pitcherStackView.arrangedSubviews.forEach { view in
            pitcherStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        if hasPitcherData {
            pitcherStackView.isHidden = false
            
            guard let awayPitcherImage, let  homePitcherImage else { return }
            // 데이터 기반 새 뷰들 생성
            let awayPitcher = createPitcherItem(imageURL: awayPitcherImage, pitcherName: awayPitcherName, teamName: awayTeamName)
            let vsLabel = UILabel()
            vsLabel.text = "VS"
            vsLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            vsLabel.textAlignment = .center
            vsLabel.textColor = .darkGray
            
            let homePitcher = createPitcherItem(imageURL: homePitcherImage, pitcherName: homePitcherName, teamName: homeTeamName)
            
            // 새 뷰 추가 (레이아웃 제약은 이미 setupPitcherUI에서 했으니까 안 건드림)
            pitcherStackView.addArrangedSubview(awayPitcher)
            pitcherStackView.addArrangedSubview(vsLabel)
            pitcherStackView.addArrangedSubview(homePitcher)
            
            // VS 라벨 너비만 따로 제약
            vsLabel.snp.makeConstraints { make in
                make.width.equalTo(40)
            }
        } else {
            pitcherStackView.isHidden = true
            
            let noDataLabel = UILabel()
            noDataLabel.text = "선발투수 정보 준비 중!\n업데이트를 기다려주세요 ⚾️"
            noDataLabel.numberOfLines = 0
            noDataLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            noDataLabel.textAlignment = .center
            
            view.addSubview(noDataLabel)
            noDataLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(pitcherTitle.snp.bottom).offset(60)
                make.left.right.equalToSuperview().inset(20)
            }
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
        if let imgURL {
            weatherImage.kf.setImage(with: imgURL)
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
        rainLabel.font = .systemFont(ofSize: 14, weight: .medium)
        rainLabel.numberOfLines = 2
        
        weatherCardView.addSubview(rainLabel)
        
        rainLabel.snp.makeConstraints { make in
            make.top.equalTo(topStack.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(weatherCardView.snp.bottom).inset(15)
        }
    }
    
    private func startAutoScroll() {
        guard !playerRecommand.isEmpty else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
        guard let currentIndexPath = carouselView.indexPathsForVisibleItems.first else { return }
        let count = currentDataSource == .playerRecommend ? playerRecommand.count : foodImages.count
        guard count > 0 else { return }
        
        var nextItem = currentIndexPath.item + 1
        
        // 마지막 아이템이면 처음으로
        if nextItem >= count {
            nextItem = 0
        }
        
        carouselView.scrollToItem(at: IndexPath(item: nextItem, section: 0),
            at: .centeredHorizontally, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAutoScroll()
    }
    
    private func searchWeather() {
        guard let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["WEATHER_API_KEY"] as? String else {
            print("API 키를 불러올 수 없습니다.")
            return
        }
        
        print("API 키: \(apiKey)")
        
        let endPt = "https://api.openweathermap.org/data/2.5/weather"
        let parameters: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "appid": apiKey,
            "units": "metric",
            "lang": "kr"
        ]
        
        AF.request(endPt, method: .get, parameters: parameters)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: WeatherRoot.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let root):
                    let weather = root.weather
                    let rain = root.rain
                    let main = root.main
                    
                    guard let weatherIcon = weather.first?.icon else { return }
                    
                    // 온도 업데이트
                    DispatchQueue.main.async {
                        self.temp = main.temp
                    }
                    
                    let rainText = (rain?.oneHour ?? 0 >= 10.0) ?
                    "우천 취소 확률이 있습니다. 관람에 유의하세요. ☔️" :
                    "우천 취소 확률이 없습니다. 즐겁게 관람하세요. ☀️"
                    
                    // 날씨 아이콘 이미지 요청
                    let iconURLString = "https://openweathermap.org/img/wn/\(weatherIcon)@2x.png"
                    guard let imageURL = URL(string: iconURLString) else { return }
                    
                    URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
                        guard let self = self,
                              let imageData = data else {
                            print("이미지 데이터 로드 실패")
                            return
                        }
                        
                        DispatchQueue.main.async {
                            // self.imgData = imageData // 필요한 경우 사용
                            self.rcText = rainText
                            self.setupWeatherUI()
                        }
                    }.resume()
                    
                case .failure(let error):
                    print("날씨 정보 요청 실패: \(error.localizedDescription)")
                }
            }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension MainInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch currentDataSource {
        case .playerRecommend:
            return playerRecommand.count
        case .defaultFood:
            return foodImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionCell.identifier, for: indexPath) as! FoodCollectionCell
        
        let imageIndex = indexPath.item % playerRecommand.count
        print("🖼 cellForItemAt: item = \(indexPath.item), imageIndex = \(imageIndex)")
        
        guard playerRecommand.indices.contains(imageIndex) else {
            print("⚠️ Out of bounds: \(imageIndex) but playerRecommand.count = \(playerRecommand.count)")
            return cell
        }
        
        let imageUrl = playerRecommand[imageIndex].reco_image
        cell.configure(with: imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let nextVC = FoodListViewController()
            navigationController?.pushViewController(nextVC, animated: true)
            print(indexPath.item)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startAutoScroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        
        let count = currentDataSource == .playerRecommend ? playerRecommand.count : foodImages.count
        guard count > 0 else { return }
        
        // 현재 보이는 아이템의 인덱스 계산
        let visibleItems = collectionView.indexPathsForVisibleItems
        if let firstVisibleItem = visibleItems.first {
            // 마지막 아이템에 도달했을 때
            if firstVisibleItem.item == count - 1 {
                // 첫 번째 아이템으로 스크롤 (애니메이션 없이)
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0),
                    at: .centeredHorizontally, animated: false)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        let imageCount = playerRecommand.count
        
        // 경계에 도달했을 때 중간으로 이동
        if currentIndex < imageCount || currentIndex > (playerRecommand.count * 200) - imageCount {
            let middleIndex = playerRecommand.count * 100
            let newIndex = middleIndex + (currentIndex % imageCount)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newIndex) * scrollView.bounds.width, y: 0), animated: false)
        }
    }
}

//MARK: - API
extension MainInfoViewController {
    func playerRecommed(stadiumlyId: String) {
        let endPt = "http://20.41.113.4/player-recommand/\(String(stadiumlyId))"
        AF.request(endPt, method: .get)
            .validate()
            .responseDecodable(of: [PlayerRecommand].self) { response in
                switch response.result {
                case.success(let decoded):
                    DispatchQueue.main.async {
                        if !decoded.isEmpty {
                            self.currentDataSource = .playerRecommend
                            self.playerRecommand = decoded
                        } else {
                            self.currentDataSource = .defaultFood
                        }
                        self.carouselView.reloadData()
                        
                        let count = self.currentDataSource == .playerRecommend ? 
                            self.playerRecommand.count : self.foodImages.count
                        if count > 0 {
                            self.carouselView.scrollToItem(at: IndexPath(item: 0, section: 0), 
                                at: .centeredHorizontally, animated: false)
                            self.startAutoScroll()
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.currentDataSource = .defaultFood
                        self.carouselView.reloadData()
                        
                        if self.foodImages.count > 0 {
                            self.carouselView.scrollToItem(at: IndexPath(item: 0, section: 0), 
                                at: .centeredHorizontally, animated: false)
                            self.startAutoScroll()
                        }
                    }
                }
            }
    }
}
