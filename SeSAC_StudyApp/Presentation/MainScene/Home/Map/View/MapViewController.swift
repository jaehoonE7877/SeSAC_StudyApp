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

final class MapViewController: BaseViewController {
    
    private let mainView = MapView()
    
    override func loadView() {
        self.view = mainView
    }
    
    private let viewModel = MapViewModel()
    private let disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func configure() {
        locationManager.delegate = self
    }
    
    private func myRegionAndAnnotation(_ title: String, _ meters: Double ,_ center: CLLocationCoordinate2D) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
        mainView.mapView.setRegion(region, animated: true)
        let pin = MKPointAnnotation()
        pin.coordinate = center
        pin.title = title
        mainView.mapView.addAnnotation(pin)
    }
    
    override func setBinding() {
        
        mainView.searchButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                
                weakSelf.transitionViewController(viewController: SearchViewController(), transitionStyle: .presentFullNavigation)
            }
            .disposed(by: disposeBag)
        
        mainView.currentButton.rx.tap
            .withUnretained(self)
            .bind { weakSelf, _ in
                guard let currentLocation = weakSelf.locationManager.location else {
                    weakSelf.checkUserDeviceLocationServiceAuthorization()
                    return
                }
                weakSelf.myRegionAndAnnotation("현재위치", 700, currentLocation.coordinate)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        
        let input = MapViewModel.Input(viewDidLoadEvent: self.rx.viewDidLoad)
        
        let output = viewModel.transform(input: input)
        
        output.isFailed
            .asDriver(onErrorJustReturn: true)
            .drive { [weak self] isFailed in
                guard let self = self else { return }
                if isFailed {
                    self.view.makeToast("데이터 통신에 실패했습니다", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        output.searchLocation
            .withUnretained(self)
            .bind { weakSelf, result in
                //weakSelf.mainView.mapView.removeAnnotation(annotation)
                result.fromQueueDB.forEach { result in
                    weakSelf.addCustomPin(sesac_image: result.sesac,
                                          coordinate: CLLocationCoordinate2D(latitude: result.lat, longitude: result.long))
                }
                result.fromQueueDBRequested.forEach { result in
                    weakSelf.addCustomPin(sesac_image: result.sesac,
                                          coordinate: CLLocationCoordinate2D(latitude: result.lat, longitude: result.long))
                }
            }
            .disposed(by: disposeBag)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus

        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
            myRegionAndAnnotation("청년취업사관학교 영등포 캠퍼스", 700, center)
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        default:
            print("DEFAULT")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            viewModel.userCurrentLocation = coordinate
        }
        //⭐️ start updatingLocation을 하고나서 멈추기 필수!
        locationManager.stopUpdatingLocation()
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
        
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            // create a view
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = true
            annotationView?.contentMode = .scaleAspectFit
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage = UIImage(named: "sesac_face_\(annotation.sesac_Image ?? 0)")
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        sesacImage?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
}

extension MapViewController {
    
    private func addCustomPin(sesac_image: Int, coordinate: CLLocationCoordinate2D){
        let pin = CustomAnnotation(sesac_Image: sesac_image, coordinate: coordinate)
        mainView.mapView.addAnnotation(pin)
    }


    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
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

