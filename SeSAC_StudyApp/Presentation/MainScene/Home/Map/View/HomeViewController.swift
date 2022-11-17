//
//  HomeViewController.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/12.
//

import UIKit
import MapKit

import CoreLocation

import RxCocoa
import RxSwift

//navigation은 이후 화면부터 생김

final class MapViewController: BaseViewController {
    
    private lazy var mapView = MKMapView()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        locationManager.delegate = self
        view.addSubview(mapView)
    }
    
    override func setConstraint() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func myRegionAndAnnotation(_ title: String, _ meters: Double ,_ center: CLLocationCoordinate2D) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
        mapView.setRegion(region, animated: true)
        
        addCustomPin(title: title, coordinate: center)
    }
    
    private func addCustomPin(title: String, coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = title
        mapView.addAnnotation(pin)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            myRegionAndAnnotation("현재 위치", 600, coordinate)
        }
        //⭐️ start updatingLocation을 하고나서 멈추기 필수!
        locationManager.stopUpdatingLocation()
    }
    
    // 4-2
    // 위치 가져오는 거 실패했을 때
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    // 사용자의 권한 상태가 바뀔 때 호출되는 메서드
    // 앱이 처음 실행됐을 때도 실행된다.-> CllocationManager() 인스턴스를 생성
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "myPin")
        
        if annotationView == nil {
            // create a view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            annotationView?.canShowCallout = true
            
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "map_marker")
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}

// 5. 위치서비스 활성화 여부, 사용자의 위치 권한 상태 확인
// 활성화 여부에 따른 Alert표시 후 설정으로 이동하는 함수
// 총 3가지 작성
extension MapViewController {

    // 5-1 사용자의 위치서비스 활성화 여부 물어보기
    // iOS 14 버전에 따른 분기 처리 밑, 위치 서비스 활성화 여부 확인
    private func checkUserDeviceLocationServiceAuthorization() {
        
        // 서비스 활성 상태
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        // 위치 서비스 활성화 상태 여부 확인
        checkUserCurrentLocationAuthorization(authorizationStatus)
    
    }
    // 5-2 사용자의 위치 권한 상태 확인
    // inPut으로 현재 서비스 활성화 상태가 들어가야 됨
    // notDetermined -> 처음 앱 실행, 버튼을 눌러서 설정하도록 권유
    // restricted, denied -> 위치 서비스가 꺼져있어 서비스 제공 x 위치 서비스 활성화 하도록 권유
    // authorizedWhenInUse ->
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            //앱을 사용하는 동안에 위치 권한 요청 + plist에 privacy(location when in use 등록 필수)
           
            // 제한이 됐다는 것이기 때문에 Alert page로 이동!
        case .restricted, .denied:
            print("RESTRICTED")
            let center = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
            myRegionAndAnnotation("청년취업사관학교 영등포 캠퍼스", 600, center)
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            // startUpdatingLocation이 있다면 stopUpdatingLocation도 구현해줘야 함
            // 아래 메서드가 실행하면 4-1의 메서드가 실행된다. 따라서 stop은 4-1에서 구현
            locationManager.startUpdatingLocation()
            
        default:
            print("DEFAULT")
        }
    }
    
    private func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

