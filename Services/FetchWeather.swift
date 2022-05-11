//
//  FetchWeather.swift
//  RxWeather
//
//  Created by  Stepanok Ivan on 09.11.2021.
//

import Foundation

struct FetchWeather {
    
    func fetchData(searchRequest: SearchRequestModel, completion: @escaping (_ weather: WeatherProtocol) -> ()) {
        print(searchRequest)
        guard let url = URL.urlForWeatherApi(searchBy: searchRequest) else { print("lol"); return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, responce, error in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        switch searchRequest.searchType {
                        case .cityName, .coordinates:
                            let results = try decoder.decode(WeatherModel.self, from: safeData)
                            DispatchQueue.main.async {
                                completion(results)
                            }
                        case .dailyHourly:
                            let results = try decoder.decode(DailyHourlyWeatherModel.self, from: safeData)
                            DispatchQueue.main.async {
                                completion(results)
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    
}

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

struct SearchRequestModel {
    let searchType: SearchType
    var cityName: String
    let latitude: Double
    let longtitude: Double
    
    func weatherUrl() -> String {
        switch searchType {
        case .cityName, .coordinates:
            return "https://api.openweathermap.org/data/2.5/weather?appid=5c6ad91dc081ba4b067f270326a0b202&units=metric&q="
        case .dailyHourly:
            return "https://api.openweathermap.org/data/2.5/onecall?appid=5c6ad91dc081ba4b067f270326a0b202&units=metric"
        }
    }
    
    init(searchType: SearchType, cityName: String) {
        self.searchType = searchType
        let encodedName = cityName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        self.cityName = encodedName
        self.latitude = 0
        self.longtitude = 0
    }
    
    init(searchType: SearchType, latitude: Double, longtitude: Double) {
        self.searchType = searchType
        self.latitude = latitude
        self.longtitude = longtitude
        self.cityName = ""
    }
}

enum SearchType {
    case cityName
    case coordinates
    case dailyHourly
}

