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
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.mapView.delegate = self
        locationManager.delegate = self
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let input = MapViewModel.Input(viewDidLoadEvent: Observable.just(()),
                                       currentButtonTap: mainView.currentButton.rx.tap,
                                       searchButtonTap: mainView.searchButton.rx.tap
                                       )
        
        let output = viewModel.transform(input: input)
        
        output.searchLocation
            .withUnretained(self)
            .bind { weakSelf, result in
                result.fromQueueDB.forEach { weakSelf.sesacSearch.append(SeSACSearchModel(lat: $0.lat, long: $0.long, gender: $0.gender, sesac: $0.sesac, background: $0.background))
                }
                result.fromQueueDBRequested.forEach { weakSelf.sesacSearch.append(SeSACSearchModel(lat: $0.lat, long: $0.long, gender: $0.gender, sesac: $0.sesac, background: $0.background))
                }
                let location = self.mainView.mapView.centerCoordinate
                self.setRegionAnnotation(location, itmes: weakSelf.sesacSearch)
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
        
        output.searchButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                let searchViewModel = SearchViewModel()
                searchViewModel.location = weakSelf.viewModel.location
                weakSelf.transitionViewController(viewController: SearchViewController(), transitionStyle: .presentFullNavigation)
            }
            .disposed(by: disposeBag)
        
        output.currentButtonTap
            .withUnretained(self)
            .bind { weakSelf, _ in
                guard let currentLocation = weakSelf.locationManager.location else {
                    weakSelf.checkUserDeviceLocationServiceAuthorization()
                    return
                }
                weakSelf.setRegionAnnotation(currentLocation.coordinate, itmes: weakSelf.sesacSearch)
            }
            .disposed(by: disposeBag)
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    private func setRegionAnnotation(_ center: CLLocationCoordinate2D, itmes: [SeSACSearchModel]) {

        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.removeAnnotations(mainView.mapView.annotations)
        mainView.mapView.setRegion(region, animated: false)
        
        var annotations: [CustomAnnotation] = []
        
        for item in itmes {
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
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
            setRegionAnnotation(center, itmes: sesacSearch)
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
        locationManager.stopUpdatingLocation()
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

