//
//  ParkingLotViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/24/25.
//

import UIKit
import SnapKit
import KakaoMapsSDK
import CoreLocation

class ParkingLotViewController: UIViewController {

    private let apiKey = "a1ca20c12106778d413b69fdaace0b23"

    var parkingPlace: [ParkingPlace]?
    
    private var poiURLMap: [String: String] = [:]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "구장 주변 주차장"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    // shadowView: 그림자용 뷰
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        return view
    }()
    
    @objc func logoTapped() {
        print("Tapped!")
        // 화면 전환 동작 (예: pull)
        let mainVC = MainInfoViewController()
        navigationController?.popViewController(animated: true)
    }
    
    
    private lazy var mapView: KMViewContainer = {
        let view = KMViewContainer()
        view.isUserInteractionEnabled = true
        view.isMultipleTouchEnabled = true
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    var mapController: KMController?
    var _observerAdded: Bool = false
    var _auth: Bool = false
    var _appear: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddSubview()
        setupConstraints()
        configureUI()
        setupProperty()
        setupMapProperty()
        addViews()
        searchParking()
    }
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Storyboard를 사용하지 않음!")
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    func setupAddSubview() {
        [mapView, titleLabel, shadowView].forEach {
            view.addSubview($0)
        }
        shadowView.addSubview(mapView)
    }
    func setupConstraints() {
        mapView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(30)
        }
        shadowView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
    }
    func configureUI() {
        view.backgroundColor = .white
    }
    func setupProperty() {
        view.isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
    }
    func setupMapProperty() {
        mapController = KMController(viewContainer: mapView)
        mapController!.delegate = self
        mapController?.prepareEngine()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
        _appear = true
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()
    }
}
//MARK: - 카카오 맵 띄우기
extension ParkingLotViewController: MapControllerDelegate {
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.866788407, latitude: 37.496659317)
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 6)
        mapController?.addView(mapviewInfo)
    }
    
    func viewInit(viewName: String) {
        print("OK")
    }
    
    // 인증 실패시 호출.
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("error code: \(errorCode)")
        print("desc: \(desc)")
        _auth = false
        switch errorCode {
        case 400:
            showToast(self.view, message: "지도 종료(API인증 파라미터 오류)")
            break
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break
        default:
            break
        }
    }
    

    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = mapView.bounds
        view.eventDelegate = self
        viewInit(viewName: viewName)
        createLabelLayer()
        createPoiStyle()
        createPois()
    }
    
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    

    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(willResignActive),
            name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(didBecomeActive),
            name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(
            self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(
            self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = false
    }
    
    @objc func willResignActive() {
        mapController?.pauseEngine()
    }
    
    @objc func didBecomeActive() {
        mapController?.activateEngine()
    }
    
    func showToast(
        _ view: UIView, message: String, duration: TimeInterval = 2.0
    ) {
        let toastLabel = UILabel(
            frame: CGRect(
                x: view.frame.size.width / 2 - 150,
                y: view.frame.size.height - 100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        UIView.animate(
            withDuration: 0.4,
            delay: duration - 0.4,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                toastLabel.alpha = 0.0
            },
            completion: { (finished) in
                toastLabel.removeFromSuperview()
            })
    }
}
//MARK: - 카카오 맵 마커
extension ParkingLotViewController: KakaoMapEventDelegate {
    
        func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
            guard let url = poiURLMap[poiID] else {
                print("❌ POI ID '\(poiID)'에 해당하는 URL을 찾을 수 없습니다.")
                for (id, url) in poiURLMap {
                    print("\(id) -> \(url)")
                }
                return
            }
            let webVC = ParkingWebViewController()
            webVC.parkingurlString = url
            present(webVC, animated: true)
        }
    
    func createLabelLayer() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KaKaoMap 뷰를 가져오기 실패 레이블레이어")
            return
        }
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KakaoMap 뷰를 가져오기 실패 표시스타일")
            return
        }
        let manager = view.getLabelManager()
        let noti1 = PoiBadge(badgeID: "badge1", image: UIImage(named: "badge"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "marker"), anchorPoint: CGPoint(x: 0.5, y: 0.5), badges: [noti1])
        let storeName = TextStyle(fontSize: 25, fontColor: UIColor.black, strokeThickness: 2, strokeColor: UIColor.white)
        let textStyle1 = PoiTextStyle(textLineStyles: [PoiTextLineStyle(textStyle: storeName)])
        let poiStyle = PoiStyle(styleID: "PerLevelStyle",styles: [PerLevelPoiStyle(iconStyle: iconStyle1, textStyle: textStyle1, level: 2)])
        manager.addPoiStyle(poiStyle)
    }
    
    func createPois() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KakaoMap 뷰를 가져오기 실패 마커찍을위치")
            return
        }
        let manager = view.getLabelManager()

        guard let places = parkingPlace,
              let layer = manager.getLabelLayer(layerID: "PoiLayer")
        else { return }
        
        
        for (index, place) in places.enumerated() {
            let poiOption = PoiOptions(styleID: "PerLevelStyle")
            poiOption.clickable = true
            poiOption.addText(PoiText(text: place.place_name, styleIndex: 0))
            poiOption.rank = 0
            guard let longitude = Double(place.x), let latitude = Double(place.y) else { return }
            if let poi = layer.addPoi(option: poiOption,at: MapPoint(longitude: longitude, latitude: latitude)) {
                // POI ID와 URL 매핑 저장
                let poiId = "agpPoiLayer\(index)"
                poiURLMap[poiId] = place.place_url
                poi.show()
            }
        }
    }
}
//MARK: - API호출
extension ParkingLotViewController {
    
    func searchParking() {
        let endPoint = "https://dapi.kakao.com/v2/local/search/keyword.json?query=주차장&category_group_code=PK6&x=\(126.866788407)&y=\(37.496659317)"
        guard let url = URL(string: endPoint) else { return }
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        let seesion = URLSession.shared
        let task = seesion.dataTask(with: request) { data, _ , error in
            if let error = error {
                print("요청 실패 Error: \(error.localizedDescription)")
                return
            }
            guard let data else {
                print("데이터가 없습니다")
                return
            }
//               print(String(data: data, encoding: .utf8) ?? "❌문자열 변환 실패")
            do {
                let decoded = try JSONDecoder().decode(ParkingLotRoot.self, from: data)
                DispatchQueue.main.async {
                    self.parkingPlace = decoded.documents
                    self.createPois()
                }
            } catch {
                print("디코딩 실패\(error)")
            }
        }
        task.resume()
    }
}

