//
//  DailyHourlyWeather.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 10.05.2022.
//

import Foundation

// MARK: - DailyHourlyWeatherModel
public struct DailyHourlyWeatherModel: Codable, WeatherProtocol {
    public let lat: Double?
    public let lon: Double?
    public let timezone: String?
    public let timezoneOffset: Int?
    public let current: Current?
    public let hourly: [Current]?
    public let daily: [Daily]?

    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset
        case current
        case hourly
        case daily
    }

    public init(lat: Double?, lon: Double?, timezone: String?, timezoneOffset: Int?, current: Current?, hourly: [Current]?, daily: [Daily]?) {
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.timezoneOffset = timezoneOffset
        self.current = current
        self.hourly = hourly
        self.daily = daily
    }
}

// MARK: - Current
public struct Current: Codable {
    public let dt: Int?
    public let sunrise: Int?
    public let sunset: Int?
    public let temp: Double?
    public let feelsLike: Double?
    public let pressure: Int?
    public let humidity: Int?
    public let dewPoint: Double?
    public let uvi: Double?
    public let clouds: Int?
    public let visibility: Int?
    public let windSpeed: Double?
    public let windDeg: Int?
    public let windGust: Double?
    public let weather: [Weather]?
    public let rain: Rain?
    public let pop: Double?

    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case feelsLike
        case pressure
        case humidity
        case dewPoint
        case uvi
        case clouds
        case visibility
        case windSpeed
        case windDeg
        case windGust
        case weather
        case rain
        case pop
    }

    public init(dt: Int?, sunrise: Int?, sunset: Int?, temp: Double?, feelsLike: Double?, pressure: Int?, humidity: Int?, dewPoint: Double?, uvi: Double?, clouds: Int?, visibility: Int?, windSpeed: Double?, windDeg: Int?, windGust: Double?, weather: [Weather]?, rain: Rain?, pop: Double?) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.uvi = uvi
        self.clouds = clouds
        self.visibility = visibility
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.windGust = windGust
        self.weather = weather
        self.rain = rain
        self.pop = pop
    }
}

// MARK: - Rain
public struct Rain: Codable {
    public let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H
    }

    public init(the1H: Double?) {
        self.the1H = the1H
    }
}

// MARK: - Weather
//public struct Weather: Codable {
//    public let id: Int?
//    public let main: Main?
//    public let weatherDescription: Description?
//    public let icon: Icon?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case main
//        case weatherDescription
//        case icon
//    }

//    public init(id: Int?, main: Main?, weatherDescription: Description?, icon: Icon?) {
//        self.id = id
//        self.main = main
//        self.weatherDescription = weatherDescription
//        self.icon = icon
//    }
//}

public enum Icon: String, Codable {
    case the04D = "04d"
    case the04N = "04n"
    case the10D = "10d"
    case the10N = "10n"
}

//public enum Main: String, Codable {
//    case clouds = "Clouds"
//    case rain = "Rain"
//}

public enum Description: String, Codable {
    case brokenClouds = "broken clouds"
    case heavyIntensityRain = "heavy intensity rain"
    case lightRain = "light rain"
    case moderateRain = "moderate rain"
    case overcastClouds = "overcast clouds"
}

// MARK: - Daily
public struct Daily: Codable {
    public let dt: Double?
    public let sunrise: Int?
    public let sunset: Int?
    public let moonrise: Int?
    public let moonset: Int?
    public let moonPhase: Double?
    public let temp: Temp?
    public let feelsLike: FeelsLike?
    public let pressure: Int?
    public let humidity: Int?
    public let dewPoint: Double?
    public let windSpeed: Double?
    public let windDeg: Int?
    public let windGust: Double?
    public let weather: [Weather]?
    public let clouds: Int?
    public let pop: Double?
    public let rain: Double?
    public let uvi: Double?

    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case moonrise
        case moonset
        case moonPhase
        case temp
        case feelsLike
        case pressure
        case humidity
        case dewPoint
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust
        case weather
        case clouds
        case pop
        case rain
        case uvi
    }

    public init(dt: Double?, sunrise: Int?, sunset: Int?, moonrise: Int?, moonset: Int?, moonPhase: Double?, temp: Temp?, feelsLike: FeelsLike?, pressure: Int?, humidity: Int?, dewPoint: Double?, windSpeed: Double?, windDeg: Int?, windGust: Double?, weather: [Weather]?, clouds: Int?, pop: Double?, rain: Double?, uvi: Double?) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
        self.moonPhase = moonPhase
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.windGust = windGust
        self.weather = weather
        self.clouds = clouds
        self.pop = pop
        self.rain = rain
        self.uvi = uvi
    }
}

// MARK: - FeelsLike
public struct FeelsLike: Codable {
    public let day: Double?
    public let night: Double?
    public let eve: Double?
    public let morn: Double?

    enum CodingKeys: String, CodingKey {
        case day
        case night
        case eve
        case morn
    }

    public init(day: Double?, night: Double?, eve: Double?, morn: Double?) {
        self.day = day
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}

// MARK: - Temp
public struct Temp: Codable {
    public let day: Double?
    public let min: Double?
    public let max: Double?
    public let night: Double?
    public let eve: Double?
    public let morn: Double?

    enum CodingKeys: String, CodingKey {
        case day
        case min
        case max
        case night
        case eve
        case morn
    }

    public init(day: Double?, min: Double?, max: Double?, night: Double?, eve: Double?, morn: Double?) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }
}
