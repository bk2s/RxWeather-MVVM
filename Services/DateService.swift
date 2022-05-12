//
//  DateFormatterService.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import Foundation

class DateService {
    
    enum DateCases {
        case hour
        case day
    }
    
    static let shared = DateService()
    
    func dayFromUnixTime(time: Double, dateCase: DateCases) -> String {
        let date = Date(timeIntervalSince1970: time)
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        switch dateCase {
        case .hour:
            dateFormatter.dateFormat = "HH" + "⁰⁰"
            if dateFormatter.string(from: currentDate) == dateFormatter.string(from: date) {
                return "Now"
            } else {
            return dateFormatter.string(from: date)
            }
        case .day:
            dateFormatter.dateFormat = "E"
            return dateFormatter.string(from: date)
            }
        }
    
}
