//
//  HourlyWeatherCollectionViewCell.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 13.04.2022.
//

import Foundation

// MARK: - Welcome
public struct WeatherModel: Codable {
    public let coord: Coord?
    public let weather: [Weather]?
    public let base: String?
    public let main: Main?
    public let visibility: Int?
    public let wind: Wind?
    public let clouds: Clouds?
    public let dt: Int?
    public let sys: Sys?
    public let timezone: Int?
    public let id: Int?
    public let name: String?
    public let cod: Int?

    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
    }

    public init(coord: Coord?, weather: [Weather]?, base: String?, main: Main?, visibility: Int?, wind: Wind?, clouds: Clouds?, dt: Int?, sys: Sys?, timezone: Int?, id: Int?, name: String?, cod: Int?) {
        self.coord = coord
        self.weather = weather
        self.base = base
        self.main = main
        self.visibility = visibility
        self.wind = wind
        self.clouds = clouds
        self.dt = dt
        self.sys = sys
        self.timezone = timezone
        self.id = id
        self.name = name
        self.cod = cod
    }
}

// MARK: - Clouds
public struct Clouds: Codable {
    public let all: Int?

    enum CodingKeys: String, CodingKey {
        case all
    }

    public init(all: Int?) {
        self.all = all
    }
}

// MARK: - Coord
public struct Coord: Codable {
    public let lon: Double?
    public let lat: Double?

    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }

    public init(lon: Double?, lat: Double?) {
        self.lon = lon
        self.lat = lat
    }
}

// MARK: - Main
public struct Main: Codable {
    public let temp: Double?
    public let feelsLike: Double?
    public let tempMin: Double?
    public let tempMax: Double?
    public let pressure: Int?
    public let humidity: Int?
    public let seaLevel: Int?
    public let grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike
        case tempMin
        case tempMax
        case pressure
        case humidity
        case seaLevel
        case grndLevel
    }

    public init(temp: Double?, feelsLike: Double?, tempMin: Double?, tempMax: Double?, pressure: Int?, humidity: Int?, seaLevel: Int?, grndLevel: Int?) {
        self.temp = temp
        self.feelsLike = feelsLike
        self.tempMin = tempMin
        self.tempMax = tempMax
        self.pressure = pressure
        self.humidity = humidity
        self.seaLevel = seaLevel
        self.grndLevel = grndLevel
    }
}

// MARK: - Sys
public struct Sys: Codable {
    public let country: String?
    public let sunrise: Int?
    public let sunset: Int?

    enum CodingKeys: String, CodingKey {
        case country
        case sunrise
        case sunset
    }

    public init(country: String?, sunrise: Int?, sunset: Int?) {
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

// MARK: - Weather
public struct Weather: Codable {
    public let id: Int?
    public let main: String?
    public let weatherDescription: String?
    public let icon: String?

    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription
        case icon
    }

    public init(id: Int?, main: String?, weatherDescription: String?, icon: String?) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

// MARK: - Wind
public struct Wind: Codable {
    public let speed: Double?
    public let deg: Int?
    public let gust: Double?

    enum CodingKeys: String, CodingKey {
        case speed
        case deg
        case gust
    }
    
    public init(speed: Double?, deg: Int?, gust: Double?) {
        self.speed = speed
        self.deg = deg
        self.gust = gust
    }
}


extension WeatherModel {
    static var emptyWeather = WeatherModel(coord: Coord(lon: 0,
                                                        lat: 0),
                                           weather: [Weather(id: 0,
                                                             main: "error",
                                                             weatherDescription: "error",
                                                             icon: "")],
                                           base: "",
                                           main: Main(temp: 0,
                                                      feelsLike: 0,
                                                      tempMin: 0,
                                                      tempMax: 0,
                                                      pressure: 0,
                                                      humidity: 0,
                                                      seaLevel: 0,
                                                      grndLevel: 0),
                                           visibility: 0,
                                           wind: Wind(speed: 0, deg: 0, gust: 0),
                                           clouds: Clouds(all: 0),
                                           dt: 0,
                                           sys: Sys(country: "", sunrise: 0, sunset: 0),
                                           timezone: 0,
                                           id: 0,
                                           name: "",
                                           cod: 0)
}
