//
//  Alertable.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/07.
//

import UIKit

protocol Alertable: AnyObject { }

extension Alertable where Self: BaseViewController {
        
    func showAlert(title: String, button: String = "확인") {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
