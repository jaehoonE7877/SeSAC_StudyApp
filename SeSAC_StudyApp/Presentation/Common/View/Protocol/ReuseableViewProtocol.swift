//
//  ReuseableViewProtocol.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/13.
//

import UIKit

protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewHeaderFooterView: ReusableViewProtocol {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
