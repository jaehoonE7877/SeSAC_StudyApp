//
//  Sequence+.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/21.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
