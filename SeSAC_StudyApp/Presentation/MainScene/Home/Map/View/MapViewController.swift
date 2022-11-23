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
    
    private var sesacSearch: [SeSACSearchModel] = []
    
    override func loadView() {
        self.view = mainView
    }
    
    private let viewModel = MapViewModel()
    private let disposeBag = DisposeBag()
    
    var cameraMove: Bool = false
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mainView.mapView.delegate = self
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.location = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
    }
    
    private func bindViewModel() {
        let input = MapViewModel.Input(viewWillAppearEvent: self.rx.viewWillAppear,
                                       currentButtonTap: mainView.currentButton.rx.tap,
                                       searchButtonTap: mainView.searchButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.searchLocation
            .withUnretained(self)
            .bind { weakSelf, result in
                result.fromQueueDB.forEach { weakSelf.sesacSearch.append(SeSACSearchModel(lat: $0.lat, long: $0.long, gender: $0.gender, sesac: $0.sesac, background: $0.background))
                }
                result.fromQueueDBRequested.forEach { weakSelf.sesacSearch.append(SeSACSearchModel(lat: $0.lat, long: $0.long, gender: $0.gender, sesac: $0.sesac, background: $0.background))
                }
                let location = self.mainView.mapView.centerCoordinate
                self.setRegionAnnotation(location, items: weakSelf.sesacSearch)
            }
            .disposed(by: disposeBag)
        
        output.isFailed
            .asDriver(onErrorJustReturn: true)
            .drive { [weak self] isFailed in
                guard let self = self else { return }
                if isFailed {
                    self.view.makeToast("데이터 통신에 실패했습니다", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.isTokenRefreshFailed
            .withUnretained(self)
            .bind { weakSelf, value in
                if value {
                    weakSelf.view.makeToast("토큰 갱신에 실패했습니다. 잠시 후 다시 시도해주세요", duration: 1, position: .center)
                }
            }
            .disposed(by: disposeBag)
        
        output.matchFailed
            .withUnretained(self)
            .bind { weakSelf, error in
                weakSelf.view.makeToast(error, duration: 1, position: .center)
            }
            .disposed(by: disposeBag)
        
        output.normalStatus
            .withUnretained(self)
            .bind { weakSelf, value in
                if value {
                    weakSelf.mainView.searchButton.setImage(UIImage(named: "map_default"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.resultMatch
            .withUnretained(self)
            .bind { weakSelf, result in
                if result.matched == 0 {
                    weakSelf.mainView.searchButton.setImage(UIImage(named: "map_matching"), for: .normal)
                } else if result.matched == 1 {
                    weakSelf.mainView.searchButton.setImage(UIImage(named: "map_matched"), for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.searchButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                let vc = SearchViewController()
                //print(weakSelf.mainView.mapView.centerCoordinate)
                vc.viewModel.location = weakSelf.mainView.mapView.centerCoordinate
                weakSelf.transitionViewController(viewController: vc, transitionStyle: .presentFullNavigation)
            }
            .disposed(by: disposeBag)
        
        output.currentButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                guard let currentLocation = weakSelf.locationManager.location else {
                    weakSelf.checkUserDeviceLocationServiceAuthorization()
                    return
                }
                weakSelf.setRegionAnnotation(currentLocation.coordinate, items: weakSelf.sesacSearch)
            }
            .disposed(by: disposeBag)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func setRegionAnnotation(_ center: CLLocationCoordinate2D, items: [SeSACSearchModel]) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        mainView.mapView.setRegion(region, animated: false)
        
        var annotations: [CustomAnnotation] = []
        
        for item in items {
            let point = CustomAnnotation(sesac_Image: item.sesac, coordinate: CLLocationCoordinate2D(latitude: item.lat, longitude: item.long))
            annotations.append(point)
        }
        mainView.mapView.addAnnotations(annotations)
    }
    
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
            
        case .restricted, .denied:
            let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
            setRegionAnnotation(center, items: sesacSearch)
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        default:
            print("DEFAULT")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            viewModel.location = coordinate
            setRegionAnnotation(coordinate, items: self.sesacSearch)
        }
        //⭐️ start updatingLocation을 하고나서 멈추기 필수!
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        if annotationView == nil {
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
        
        let location = mapView.centerCoordinate
        
        if animated == false {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                usleep(800000)
                if location == mapView.centerCoordinate {
                    self.viewModel.location = location
                    self.viewModel.requestSesacUser(userCurrentLocation: location) { result in
                        switch result{
                        case .success(let result):
                            result.fromQueueDB.forEach { self.sesacSearch.append(SeSACSearchModel(lat: $0.lat, long: $0.long, gender: $0.gender, sesac: $0.sesac, background: $0.background))
                            }
                            result.fromQueueDBRequested.forEach { self.sesacSearch.append(SeSACSearchModel(lat: $0.lat, long: $0.long, gender: $0.gender, sesac: $0.sesac, background: $0.background))
                            }
                            let location = self.mainView.mapView.centerCoordinate
                            self.setRegionAnnotation(location, items: self.sesacSearch)
                        case .failure(let error):
                            self.view.makeToast(error.errorDescription, duration: 1, position: .center)
                        }
                    }
                }
            }
        }
    }
}

extension MapViewController {

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

