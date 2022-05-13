//
//  FetchWeather.swift
//  RxWeather
//
//  Created by  Stepanok Ivan on 09.11.2021.
//

import Foundation

struct FetchWeather {
    
    func fetchData(searchRequest: SearchRequestModel, completion: @escaping (_ weather: WeatherProtocol) -> ()) {
        guard let url = URL.urlForWeatherApi(searchBy: searchRequest) else { return }
        print(">>>>", url)
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

struct SearchRequestModel {
    let searchType: SearchType
    var cityName: String
    let latitude: Double
    let longtitude: Double
    
    func weatherUrl() -> String {
        switch searchType {
        case .cityName:
            return "https://api.openweathermap.org/data/2.5/weather?appid=5c6ad91dc081ba4b067f270326a0b202&units=metric&lang=ru&q="
        case .coordinates:
            return "https://api.openweathermap.org/data/2.5/weather?appid=5c6ad91dc081ba4b067f270326a0b202&units=metric&lang=ru"
        case .dailyHourly:
            return "https://api.openweathermap.org/data/2.5/onecall?appid=5c6ad91dc081ba4b067f270326a0b202&units=metric&lang=ru"
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

