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
        let latLon = PublishSubject<Coordinates>()
        let loading = PublishSubject<LoadingState>()
        
        func fetch(_ weather: SearchModel) {
            switch weather {
            case .citySearch(let currentWeather):
                detailModels.onNext(self.generateModel(from: currentWeather))
                weatherIcon.onNext(ConditionName.shared.conditionName(conditionId: currentWeather.weather?[0].id ?? 0))
                cityName.onNext(currentWeather.name ?? "Noname")
                latLon.onNext(Coordinates(lat: currentWeather.coord?.lat ?? 0, lon: currentWeather.coord?.lon ?? 0))
                let dailyHourlyRequest = SearchRequestModel(searchType: .dailyHourly, latitude: currentWeather.coord?.lat ?? 0, longtitude: currentWeather.coord?.lon ?? 0)
                loading.onNext(.start)
                self.fetchWeather.fetchData(searchRequest: dailyHourlyRequest) { dh in
                    loading.onNext(.stop)
                    switch dh {
                    case .citySearch( _):
                        break
                    case .dailySearch(let dailyHourlyWeatherModel):
                        hourlyWeatherModel.onNext(self.generateHourly(from: dailyHourlyWeatherModel))
                        dailyWeatherModel.onNext(self.generateDaily(from: dailyHourlyWeatherModel))
                    }
                }
                
            case .dailySearch(_):
                break
            }
            
        }
        
        input.weatherDay.bind { weather in
            detailModels.onNext(weather)
        }.disposed(by: bag)
        
        input.coordinates.bind { coord in
            let coordRequest = SearchRequestModel(searchType: .coordinates,
                                                  latitude: coord.lat,
                                                  longtitude: coord.lon)
            loading.onNext(.start)
            self.fetchWeather.fetchData(searchRequest: coordRequest) { weather in
                loading.onNext(.stop)
                fetch(weather)
            }
        }.disposed(by: bag)
        
        input.cityName.bind(onNext: { city in
            let cityRequest = SearchRequestModel(searchType: .cityName, cityName: city)
            loading.onNext(.start)
            self.fetchWeather.fetchData(searchRequest: cityRequest, completion: { weather in
                loading.onNext(.stop)
                fetch(weather)
            })
        }).disposed(by: bag)
        return Output(weatherModel: detailModels,
                      hourlyWeatherModel: hourlyWeatherModel,
                      dailyWeatherModel: dailyWeatherModel,
                      weatherIcon: weatherIcon,
                      cityName: cityName,
                      latLon: latLon,
                      loading: loading
        )
    }
    
    // MARK: - Genarate Models
    func generateModel(from model: WeatherModel) -> [WeatherDetailModel] {
        let temperature = WeatherDetailModel(type: .temperature,
                                             description: String(Int(model.main?.temp ?? 0)) + "°",
                                             windDirection: nil)
        let humidity = WeatherDetailModel(type: .humidity,
                                          description: String(model.main?.humidity ?? 0) + "%",
                                          windDirection: nil)
        let wind = WeatherDetailModel(type: .wind,
                                      description: String(model.wind?.speed ?? 0) + "м/сек",
                                      windDirection: model.wind?.deg)
        return [temperature, humidity, wind]
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
    
    func generateModelFrom(model: DailyWeatherModel) -> [WeatherDetailModel] {
        let temp = WeatherDetailModel(type: .temperature,
                                      description: String(Int(model.maxDayTemperature)) + "°",
                                      windDirection: nil)
        let humidity = WeatherDetailModel(type: .humidity,
                                          description: String(model.humidity) + "%",
                                          windDirection: nil)
        let wind = WeatherDetailModel(type: .wind,
                                      description: String(model.windSpeed) + "м/сек", windDirection: model.windDegree )
        return [temp, humidity, wind]
        
    }
    
    func generateDaily(from model: DailyHourlyWeatherModel) -> [DailyWeatherModel] {
        var dailyWeather: [DailyWeatherModel] = []
        _ = model.daily?.compactMap({ daily in
            let weather = DailyWeatherModel(day: daily.dt ?? 0,
                                            maxDayTemperature: daily.temp?.max ?? 0,
                                            maxNightTemperature:  daily.temp?.min ?? 0,
                                            weatherIcon: ConditionName.shared.conditionName(conditionId: daily.weather?[0].id ?? 0),
                                            humidity: daily.humidity ?? 0,
                                            windSpeed: daily.windSpeed ?? 0,
                                            windDegree: daily.windDeg ?? 0)
            dailyWeather.append(weather)
        })
        return dailyWeather
    }
    
    
    
    // MARK: - Input&Output
    struct Input {
        let geoTapped: Driver<Void>
        let cityName: PublishSubject<String>
        let coordinates: PublishSubject<Coordinates>
        let weatherDay: PublishSubject<[WeatherDetailModel]>
    }
    
    struct Output {
        let weatherModel: PublishSubject<[WeatherDetailModel]>
        let hourlyWeatherModel: PublishSubject<[HourlyWeatherModel]>
        let dailyWeatherModel: PublishSubject<[DailyWeatherModel]>
        let weatherIcon: PublishSubject<String>
        let cityName: PublishSubject<String>
        let latLon: PublishSubject<Coordinates>
        let loading: PublishSubject<LoadingState>
    }
}
