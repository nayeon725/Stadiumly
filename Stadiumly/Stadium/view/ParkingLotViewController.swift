//
//  ParkingLotViewController.swift
//  Stadiumly
//
//  Created by 김나연 on 5/24/25.
//

import UIKit
import SnapKit
import MapKit

class ParkingLotViewController: UIViewController {
    
    // 캐시 변수
    var geocodingCache: [String: CLLocationCoordinate2D] = [:]
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var parkingAnnotations: [ParkingAnnotation] = []
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "구장 주변 주차장"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 10
        map.clipsToBounds = true
        return map
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        centerMapOnLocation()
        parkingLotAnnotation()
        
        view.backgroundColor = .white
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.496659317, longitude: 126.866788407)
        annotation.title = "고척 스카이돔"
        mapView.addAnnotation(annotation)
        mapView.delegate = self
    }
    
    private func configureUI() {
        view.addSubview(titleLabel)
        view.addSubview(shadowView)
        shadowView.addSubview(mapView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }
        
        // 그림자 뷰 제약
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
    
    private func centerMapOnLocation() {
        let coordinate = CLLocationCoordinate2D(latitude:  37.496659317, longitude: 126.866788407)
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 10000,
                                        longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    
    func parkingLotAnnotation() {
        guard let endPt = "http://openapi.seoul.go.kr:8088/4965454f67736b6435354d516f646a/json/GetParkingInfo/1/200/구로구".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: endPt)
        else {
            print("URL 생성 실패")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data else {
                print("데이터 없음")
                return
            }
            
            do {
                let root = try JSONDecoder().decode(ParkingLotRoot.self, from: data)
                let getParkingInfo = root.GetParkingInfo
                let parkingLots = root.GetParkingInfo.row
                guard !getParkingInfo.row.isEmpty else {
                    print("주차장 정보가 없습니다.")
                    return
                }
                
                self.pinningParkingCoordinates(from: parkingLots)
            } catch {
                print("JSON 디코딩 실패: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    // API 주소 좌표로 변환해서 주차장 핀꼽기
    func pinningParkingCoordinates(from parkingLots: [Row]) {
        var totalCount = parkingLots.count
        
        for item in parkingLots {
            if let cachedCoord = geocodingCache[item.ADDR] {
                
                // 캐시에 있는 좌표 사용
                let annotation = ParkingAnnotation()
                annotation.title = item.PKLT_NM
                annotation.coordinate = cachedCoord
                annotation.parkingData = item
                self.parkingAnnotations.append(annotation)
                print("루프 중  : \(parkingLots.count)")
                print("루프중 : \(self.parkingAnnotations.count)")
                
                if self.parkingAnnotations.count == totalCount {
                    DispatchQueue.main.async {
                        self.mapView.addAnnotations(self.parkingAnnotations)
                    }
                }
            } else {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(item.ADDR) { places, _ in
                    if let place = places?.first, let location = place.location {
                        let coord = location.coordinate
                        // 캐시에 저장
                        self.geocodingCache[item.ADDR] = coord
                        
                        let annotation = ParkingAnnotation()
                        annotation.title = item.PKLT_NM
                        annotation.coordinate = coord
                        annotation.parkingData = item
                        self.parkingAnnotations.append(annotation)
                    } else {
                        totalCount -= 1
                    }
                    
                    if self.parkingAnnotations.count == totalCount {
                        DispatchQueue.main.async {
                            self.mapView.addAnnotations(self.parkingAnnotations)
                        }
                    }
                }
            }
        }
    }
}


// 마커 카드에 커스텀 데이터를 뿌리기 위한 타입캐스팅
class ParkingAnnotation: MKPointAnnotation {
    var parkingData: Row?
}

extension ParkingLotViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 주차장 마커
        if annotation is ParkingAnnotation {
            let identifier = "ParkingLot"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.markerTintColor = .gray
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }

        // 야구장 마커
        let identifier = "Stadium"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.markerTintColor = .white
                annotationView?.glyphText = "🏟️"
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
}
