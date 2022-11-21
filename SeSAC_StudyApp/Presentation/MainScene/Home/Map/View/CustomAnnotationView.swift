//
//  CustomAnnotationView.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/22.
//

import UIKit
import MapKit

final class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}

final class CustomAnnotation: NSObject, MKAnnotation {
    
    let sesac_Image: Int?
    let coordinate: CLLocationCoordinate2D
    
    init(
        sesac_Image: Int?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.sesac_Image = sesac_Image
        self.coordinate = coordinate
        
        super.init()
    }
    
}
