//
//  Sequence.swift
//  RxWeather MVVM
//
//  Created by ┬áStepanok Ivan on 12.05.2022.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
