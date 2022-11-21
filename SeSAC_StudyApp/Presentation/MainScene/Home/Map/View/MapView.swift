//
//  MapView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/17.
//

import UIKit
import MapKit


final class MapView: BaseView {
    
    lazy var mapView = MKMapView().then {
        $0.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
    }
    
    let pinImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "map_marker")
    }
    
    let currentButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8
        $0.setImage(UIImage(named: "place"), for: .normal)
    }
    
    lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(named: "map_default"), for: .normal)
        $0.layer.cornerRadius = $0.layer.frame.size.width / 2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func configure() {
        self.addSubview(mapView)
        [currentButton, pinImageView, searchButton].forEach{ mapView.addSubview($0) }
    }
    
    override func setConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pinImageView.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(45)
            make.center.equalTo(self.safeAreaLayoutGuide)
        }
        
        currentButton.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.leading.equalTo(mapView.snp.leading).offset(16)
            make.top.equalTo(212)
        }
        
        searchButton.snp.makeConstraints { make in
            make.size.equalTo(64)
            make.trailing.equalTo(mapView.snp.trailing).inset(16)
            make.bottom.equalTo(-122)
        }
    }
}
