//
//  ReuseableViewProtocol.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/13.
//

import UIKit

public protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableViewProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableViewProtocol {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
