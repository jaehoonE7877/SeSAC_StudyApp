//
//  Reactive+MKMapView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/22.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit

class RxMKMapViewDelegateProxy: DelegateProxy<MKMapView, MKMapViewDelegate>, DelegateProxyType, MKMapViewDelegate {

    static func registerKnownImplementations() {
        self.register { (mapView) -> RxMKMapViewDelegateProxy in
            RxMKMapViewDelegateProxy(parentObject: mapView, delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: MKMapView) -> MKMapViewDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: MKMapViewDelegate?, to object: MKMapView) {
        object.delegate = delegate
    }
}

extension Reactive where Base: MKMapView {
    var delegate: DelegateProxy<MKMapView, MKMapViewDelegate> {
        return RxMKMapViewDelegateProxy.proxy(for: self.base)
    }

    var regionDidChangeAnimated: Observable<Bool> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:regionDidChangeAnimated:)))
            .map({ (parameters) in
                return parameters[0] as? Bool ?? false
            })
    }

    var didUpdate: Observable<CLLocationCoordinate2D> {
        return delegate.methodInvoked(#selector(MKMapViewDelegate.mapView(_:didUpdate:))).map({ (parameters) in
            return (parameters[1] as? MKUserLocation)?.coordinate ?? CLLocationCoordinate2D.init(latitude: 0, longitude: 0)
        })
    }
}
