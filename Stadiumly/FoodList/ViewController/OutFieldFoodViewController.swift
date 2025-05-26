//
//  OutFieldFoodViewController.swift
//  Stadiumly
//
//  Created by Hee  on 5/23/25.
//

import UIKit
import SnapKit
import KakaoMapsSDK

//구장 외 먹거리
class OutFieldFoodViewController: UIViewController {
    
    
    private lazy var outFieldMapView: KMViewContainer = {
        let view = KMViewContainer()
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
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    //스토리보드 안쓸경우 처리
    required init?(coder: NSCoder) {
        fatalError("Storyboard를 사용하지 않음!")
    }
    
    deinit {
        mapController?.pauseEngine()
        mapController?.resetEngine()
        
        print("deinit")
    }
    
    //addSubView
    func setupAddSubview() {
        [outFieldMapView].forEach {
            view.addSubview($0)
        }
    }
    //오토 레이아웃
    func setupConstraints() {
        outFieldMapView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    //UI 속성
    func configureUI() {
    }
    //property
    func setupProperty() {
    }
    //map property
    func setupMapProperty() {
        //KMcontroller 생성
        mapController = KMController(viewContainer: outFieldMapView)
        mapController!.delegate = self
        mapController?.prepareEngine()//엔진 초기화. 엔진 내부 객체 생성 및 초기화가 진행된다
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObservers()
        _appear = true
        
        if mapController?.isEngineActive == false {
            mapController?.activateEngine()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        _appear = false
        mapController?.pauseEngine()  //렌더링 중지.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        removeObservers()
        mapController?.resetEngine()     //엔진 정지. 추가되었던 ViewBase들이 삭제된다.
    }
    
}
//MARK: - kakao Map 관련
extension OutFieldFoodViewController: MapControllerDelegate {
    
    func addViews() {
        let defaultPosition: MapPoint = MapPoint(longitude: 126.866788407, latitude: 37.496659317)
        // MapviewInfo생성.
        // viewName과 사용할 viewInfoName, defaultPosition과 level을 설정한다.
        let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 7)
        // mapviewInfo를 파라미터로 mapController를 통해 생성한 뷰의 객체를 얻어온다.
        // 정상적으로 생성되면 MapControllerDelegate의 addViewSucceeded가 호출되고, 실패하면 addViewFailed가 호출된다.
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
            break;
        case 401:
            showToast(self.view, message: "지도 종료(API인증 키 오류)")
            break;
        case 403:
            showToast(self.view, message: "지도 종료(API인증 권한 오류)")
            break;
        case 429:
            showToast(self.view, message: "지도 종료(API 사용쿼터 초과)")
            break;
        case 499:
            showToast(self.view, message: "지도 종료(네트워크 오류) 5초 후 재시도..")
            
            // 인증 실패 delegate 호출 이후 5초뒤에 재인증 시도..
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                print("retry auth...")
                
                self.mapController?.prepareEngine()
            }
            break;
        default:
            break;
        }
    }
    
    //addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        let view = mapController?.getView("mapview") as! KakaoMap
        view.viewRect = outFieldMapView.bounds    //뷰 add 도중에 resize 이벤트가 발생한 경우 이벤트를 받지 못했을 수 있음. 원하는 뷰 사이즈로 재조정.
        viewInit(viewName: viewName)
        createLabelLayer()
        createPoiStyle()
        createPois()
    }
    
    //addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
    func addViewFailed(_ viewName: String, viewInfoName: String) {
        print("Failed")
    }
    
    //Container 뷰가 리사이즈 되었을때 호출된다. 변경된 크기에 맞게 ViewBase들의 크기를 조절할 필요가 있는 경우 여기에서 수행한다.
    func containerDidResized(_ size: CGSize) {
        let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
        mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)   //지도뷰의 크기를 리사이즈된 크기로 지정한다.
    }
    
    func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = true
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        _observerAdded = false
    }
    
    @objc func willResignActive(){
        mapController?.pauseEngine()  //뷰가 inactive 상태로 전환되는 경우 렌더링 중인 경우 렌더링을 중단.
    }
    
    @objc func didBecomeActive(){
        mapController?.activateEngine() //뷰가 active 상태가 되면 렌더링 시작. 엔진은 미리 시작된 상태여야 함.
    }
    
    func showToast(_ view: UIView, message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300, height: 35))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        view.addSubview(toastLabel)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 0.4,
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
//카카오 맵 마커
extension OutFieldFoodViewController {
    // Poi생성을 위한 LabelLayer 생성
    func createLabelLayer() {
        //맵뷰 객체를 가져오기
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KaKaoMap 뷰를 가져오기 실패!")
            return
        }
        //라벨매니저를 가져오기 POI 라벨을 관리하는 역할을함
        let manager = view.getLabelManager()
        //라벨 레이어 옵션을 생성
        let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
        //이줄이 있어야 레이어가 추가됨 레이어위에 POI(마커)나 라벨을 올릴수 있어서
        let _ = manager.addLabelLayer(option: layerOption)
    }
    
    // Poi 표시 스타일 생성
    func createPoiStyle() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KakaoMap 뷰를 가져오기 실패!")
            return
        }
        let manager = view.getLabelManager()
        
        // PoiBadge는 스타일에도 추가될 수 있다. 이렇게 추가된 Badge는 해당 스타일이 적용될 때 함께 그려진다.
        //객체생성해서 뱃지구분ID만들고 이미지, 아이콘에서 어느 위치에 그려질지 좌표로 설정, 렌더링순서
        let noti1 = PoiBadge(badgeID: "badge1", image: UIImage(named: "no1"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
        //Poi아이콘 스타일 설정 symbol 마커아이콘 이미지, 마커이미지에서 기준점이 어디인지 설정, 함께 표시될 뱃지목록
        let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "no2"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [noti1])
    
        // 5~11, 12~21 에 표출될 스타일을 지정한다.
        //줌 레벨별 스타일을 묶어서 스타일 정의 ID로 스타일을 등록 
        let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
            PerLevelPoiStyle(iconStyle: iconStyle1, level: 5)
        ])
        manager.addPoiStyle(poiStyle)
        
    }
    //지도에 마커찍을 위치 지정 + 해당마커 스타일, 뱃지 적용 + 지도에보여주기 역할
    func createPois() {
        guard let view = mapController?.getView("mapview") as? KakaoMap else {
            print("KakaoMap 뷰를 가져오기 실패!")
            return
        }
        //라벨 관리하는 객체 가져오기
        let manager = view.getLabelManager()
        //ID를 가진 라벨 레이어를 가져오기 이 레이어에 POI들을 추가
        let layer = manager.getLabelLayer(layerID: "PoiLayer")
        //POI(마커)를 만들기 위한 옵션 설정, 줌 레벨에따라 마커 생김새가 달라지는 설정
        let poiOption = PoiOptions(styleID: "PerLevelStyle")
        //POI우선순위 설정 낮을수록 우선순위
        poiOption.rank = 0
        //설정한 옵션, 좌표를 사용해서 POI를 추가
        let poi1 = layer?.addPoi(option:poiOption, at: MapPoint(longitude: 126.866788407, latitude: 37.496659317))
        // Poi 개별 Badge추가. 즉, 아래에서 생성된 Poi는 Style에 빌트인되어있는 badge와, Poi가 개별적으로 가지고 있는 Badge를 갖게 된다.
        //뱃지에 ID만들어서 위치를 오프셋설정, Z0rder 로 우선순위 지정
        let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "no4"), offset: CGPoint(x: 0, y: 0), zOrder: 1)
        //만든 뱃지 POI추가
        poi1?.addBadge(badge)
        //POI 지도에 표시하기
        poi1?.show()
        //추가한 noti뱃지를 지도에 표시
        poi1?.showBadge(badgeID: "noti")
    }
}
