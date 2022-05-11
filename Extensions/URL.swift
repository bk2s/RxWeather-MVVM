//
//  URL.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 12.05.2022.
//

import Foundation

extension URL {
    static func urlForAutocomplete(pred: String) -> URL? {
        let encodedCity = pred.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        let autocompleteUrl = "https://api.locationiq.com/v1/autocomplete.php?key=pk.dfa5f7c230ad3657a2288c9e18674fad&limit=10&accept-language=ua&q="
        return URL(string: autocompleteUrl + encodedCity)
    }
    
    static func urlForWeatherApi(searchBy: SearchRequestModel) -> URL? {
        switch searchBy.searchType {
        case .cityName:
            let cityName = searchBy.cityName
            return URL(string: searchBy.weatherUrl() + cityName)
        case .coordinates:
            let latitude = searchBy.latitude, longtitude = searchBy.longtitude
            let urlString = "&lat=\(latitude)&lon=\(longtitude)"
            return URL(string: searchBy.weatherUrl() + urlString)
        case .dailyHourly:
            let latitude = searchBy.latitude, longtitude = searchBy.longtitude
            let urlString = "&lat=\(latitude)&lon=\(longtitude)"
            return URL(string: searchBy.weatherUrl() + urlString)
        }
    }
}
