//
//  OutFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import KakaoMapsSDK
import SnapKit
import UIKit


protocol FoodSearchDelegate: AnyObject {
    func didReceiveSearchResults(_ places: [Place])
}
//구장 외 먹거리
class OutFieldFoodViewController: UIViewController {

    var searchPlace: [Place]?
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    var delegate: FoodSearchDelegate?
    
    private var poiURLMap: [String: String] = [:]
    
    private lazy var outFieldMapView: KMViewContainer = {
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
        updateStadiumInfo()
        setupAddSubview()
        setupConstraints()
        setupProperty()
        setupMapProperty()
        addViews()
    }

    private func updateStadiumInfo() {
        if let stadium = DataManager.shared.selectedStadium {
            lat = stadium.latitude
            lon = stadium.longitude
        }
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
        [outFieldMapView].forEach {
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        outFieldMapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    func setupProperty() {
        view.isUserInteractionEnabled = true
        outFieldMapView.isUserInteractionEnabled = true
    }
   
    func setupMapProperty() {
        //KMcontroller 생성
        mapController = KMController(viewContainer: outFieldMapView)
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
//MARK: - kakao Map 관련
extension OutFieldFoodViewController: MapControllerDelegate {
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: lon, latitude: lat)

        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map",
                                                   defaultPosition: defaultPosition, defaultLevel: 6)
    
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
        view.viewRect = outFieldMapView.bounds
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
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)  //지도뷰의 크기를 리사이즈된 크기로 지정한다.
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
extension OutFieldFoodViewController: FoodSearchDelegate, KakaoMapEventDelegate {
   
    func poiDidTapped(kakaoMap: KakaoMap, layerID: String, poiID: String, position: MapPoint) {
        print(" ✔️ 마커 POI 클릭됨")
        print("   POI ID: \(poiID)")
        // 매핑된 URL 찾기
        guard let url = poiURLMap[poiID] else {
            print("❌ POI ID '\(poiID)'에 해당하는 URL을 찾을 수 없습니다.")
            for (id, url) in poiURLMap {
                print("\(id) -> \(url)")
            }
            return
        }
        print("✅ 선택된 URL: \(url)")
        let webVC = OutFieldWebViewController()
        webVC.urlString = url
        present(webVC, animated: true)
    }
    func didReceiveSearchResults(_ places: [Place]) {
        print("🍱 검색 결과 정보 : \(places.count)개")
        self.searchPlace = places
        DispatchQueue.main.async {
            self.createPois()
        }
    }
    
    func createLabelLayer() {

        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KaKaoMap 뷰를 가져오기 실패 레이블레이어")
            return
        }
        let manager = view.getLabelManager()
        let layerOption = LabelLayerOptions(
            layerID: "PoiLayer", competitionType: .none,
            competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    func createPoiStyle() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KakaoMap 뷰를 가져오기 실패 표시스타일")
            return
        }
        let manager = view.getLabelManager()
        let noti1 = PoiBadge(
            badgeID: "badge1", image: UIImage(named: "badge"),
            offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        let iconStyle1 = PoiIconStyle(
            symbol: UIImage(named: "marker"),
            anchorPoint: CGPoint(x: 0.5, y: 0.5), badges: [noti1])
        let storeName = TextStyle(
            fontSize: 25, fontColor: UIColor.black, strokeThickness: 2,
            strokeColor: UIColor.white)
        let textStyle1 = PoiTextStyle(textLineStyles: [
            PoiTextLineStyle(textStyle: storeName)
        ])
        let poiStyle = PoiStyle(
            styleID: "PerLevelStyle",
            styles: [
                PerLevelPoiStyle(
                    iconStyle: iconStyle1, textStyle: textStyle1, level: 2)
            ])
        manager.addPoiStyle(poiStyle)
        
    }
    func createPois() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KakaoMap 뷰를 가져오기 실패 마커찍을위치")
            return
        }
        let manager = view.getLabelManager()
        guard let places = searchPlace,
              let layer = manager.getLabelLayer(layerID: "PoiLayer")
        else { return }
        manager.removeLabelLayer(layerID: "PoiLayer")
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        guard let newLayer = manager.addLabelLayer(option: layerOption) else {
            print("새 레이어 생성 실패")
            return
        }
        poiURLMap.removeAll()

        for (index, place) in places.enumerated() {
            let poiOption = PoiOptions(styleID: "PerLevelStyle")
            poiOption.clickable = true
            poiOption.addText(PoiText(text: place.place_name, styleIndex: 0))
            poiOption.rank = 0
            guard let longitude = Double(place.x), let latitude = Double(place.y) else { return }
            if let poi = layer.addPoi(option: poiOption,at: MapPoint(longitude: longitude, latitude: latitude)) {
                let poiId = "agpPoiLayer\(index)"
                poiURLMap[poiId] = place.place_url
                poi.show()
            }
        }
    }
}
