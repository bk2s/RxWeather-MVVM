//
//  ConditionName.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import Foundation

class ConditionName {
    static let shared = ConditionName()
    
    public func conditionName(conditionId: Int) -> String {
        switch conditionId {
        case 200...202:
            return "cloud.bolt.rain"
        case 210...221:
            return "cloud.bolt"
        case 230...232:
            return "cloud.bolt.rain"
        case 300...312:
            return "cloud.drizzle"
        case 313...314:
            return "cloud.heavyrain"
        case 321:
            return "cloud.drizzle"
        case 500...501:
            return "cloud.drizzle"
        case 502...504:
            return "cloud.rain"
        case 511:
            return "cloud.sleet"
        case 520...531:
            return "cloud.heavyrain"
        case 600...602:
            return "cloud.snow"
        case 611:
            return "thermometer.snowflake"
        case 612...622:
            return "cloud.sleet"
        case 701...721:
            return "cloud.fog"
        case 731:
            return "sun.dust"
        case 741:
            return "cloud.fog"
        case 751...762:
            return "sun.dust"
        case 771:
            return "wind"
        case 781:
            return "tornado"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803...804:
            return "smoke"
        default:
            return "questionmark"
        }
    }
}
