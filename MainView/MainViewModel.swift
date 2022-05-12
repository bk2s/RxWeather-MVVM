//
//  MainViewModel.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 26.04.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelInputOutput: AnyObject {
    associatedtype Input
    associatedtype Output
}

protocol ViewModel: ViewModelInputOutput {
    func transform(input: Input) -> Output
}

class MainViewModel: ViewModel {
    public let bag = DisposeBag()
    private let fetchWeather = FetchWeather()
    
    // MARK: - Transform

    
    func transform(input: Input) -> Output {
        let detailModels = PublishSubject<[WeatherDetailModel]>()
        let hourlyWeatherModel = PublishSubject<[HourlyWeatherModel]>()
        let dailyWeatherModel = PublishSubject<[DailyWeatherModel]>()
        let weatherIcon = PublishSubject<String>()
        let cityName = PublishSubject<String>()
        let latLon = PublishSubject<LatLon>()
        
        func fetch(_ weather: WeatherProtocol) {
            let currentWeather = weather as! WeatherModel
            detailModels.onNext(self.generateModel(from: currentWeather))
            
            print(">>>>> currentName", currentWeather.name)
            weatherIcon.onNext(ConditionName.shared.conditionName(conditionId: currentWeather.weather?[0].id ?? 0))
            cityName.onNext(currentWeather.name ?? "Noname")
            latLon.onNext(LatLon(lat: currentWeather.coord?.lat ?? 0, lon: currentWeather.coord?.lon ?? 0))
            
            let dailyHourlyRequest = SearchRequestModel(searchType: .dailyHourly, latitude: currentWeather.coord?.lat ?? 0, longtitude: currentWeather.coord?.lon ?? 0)
            self.fetchWeather.fetchData(searchRequest: dailyHourlyRequest) { dh in
                let dailyHourly = dh as! DailyHourlyWeatherModel
                hourlyWeatherModel.onNext(self.generateHourly(from: dailyHourly))
                dailyWeatherModel.onNext(self.generateDaily(from: dailyHourly))
            }
        }
        
        
        input.coordinates.bind { coord in
            let coordRequest = SearchRequestModel(searchType: .coordinates,
                                                  latitude: coord.lat,
                                                  longtitude: coord.lon)
            self.fetchWeather.fetchData(searchRequest: coordRequest) { weather in
                fetch(weather)
            }
        }.disposed(by: bag)

        input.cityName.bind(onNext: { city in
            print(city)
            let cityRequest = SearchRequestModel(searchType: .cityName, cityName: city)
            self.fetchWeather.fetchData(searchRequest: cityRequest, completion: { weather in
                fetch(weather)
            })
        }).disposed(by: bag)
        return Output(weatherModel: detailModels,
                      hourlyWeatherModel: hourlyWeatherModel,
                      dailyWeatherModel: dailyWeatherModel,
                      weatherIcon: weatherIcon,
                      cityName: cityName,
                      latLon: latLon
        )
    }
    
    // MARK: - Genarate Models
    func generateModel(from model: WeatherModel) -> [WeatherDetailModel] {
        var detailModels: [WeatherDetailModel] = []
        let temperature = WeatherDetailModel(type: .temperature,
                                             description: String(Int(model.main?.temp ?? 0)) + "°",
                                             windDirection: nil)
        let humidity = WeatherDetailModel(type: .humidity,
                                          description: String(model.main?.humidity ?? 0) + "%",
                                          windDirection: nil)
        let wind = WeatherDetailModel(type: .wind,
                                      description: String(model.wind?.speed ?? 0) + "м/сек",
                                      windDirection: model.wind?.deg)
        detailModels.append(temperature)
        detailModels.append(humidity)
        detailModels.append(wind)
        return detailModels
    }
    
    func generateHourly(from model: DailyHourlyWeatherModel) -> [HourlyWeatherModel] {
        var hourlyWeather: [HourlyWeatherModel] = []
        _ = model.hourly?.compactMap({ hourly in
            let weather = HourlyWeatherModel(day: Double(hourly.dt ?? 0),
                                             weatherImage: ConditionName.shared.conditionName(conditionId: hourly.weather?[0].id ?? 0),
                                             temp: Int(hourly.temp ?? 0))
            hourlyWeather.append(weather)
        })
        return hourlyWeather
    }
    
    func generateDaily(from model: DailyHourlyWeatherModel) -> [DailyWeatherModel] {
        var dailyWeather: [DailyWeatherModel] = []
        _ = model.daily?.compactMap({ daily in
            let weather = DailyWeatherModel(day: daily.dt ?? 0,
                                            maxDayTemperature: daily.temp?.max ?? 0,
                                            maxNightTemperature:  daily.temp?.min ?? 0,
                                            weatherIcon: ConditionName.shared.conditionName(conditionId: daily.weather?[0].id ?? 0),
                                            isSelected: false)
            dailyWeather.append(weather)
        })
        return dailyWeather
    }
    

    
    // MARK: - Input&Output
    struct Input {
        let geoTapped: Driver<Void>
        let cityName: PublishSubject<String>
        let coordinates: PublishSubject<LatLon>
    }
    
    struct Output {
        let weatherModel: PublishSubject<[WeatherDetailModel]>
        let hourlyWeatherModel: PublishSubject<[HourlyWeatherModel]>
        let dailyWeatherModel: PublishSubject<[DailyWeatherModel]>
        let weatherIcon: PublishSubject<String>
        let cityName: PublishSubject<String>
        let latLon: PublishSubject<LatLon>
    }
}
