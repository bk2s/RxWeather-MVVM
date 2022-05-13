//
//  ViewController.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 13.04.2022.
//

import UIKit
import RxSwift
import RxCocoa

struct Coordinates {
    var lat: Double
    var lon: Double
}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel = MainViewModel()
    var bag = DisposeBag()
    public let cityName = PublishSubject<String>()
    public let coordinates = PublishSubject<Coordinates>()
    public let weatherDay = PublishSubject<[WeatherDetailModel]>()
    var latLon = Coordinates(lat: 0, lon: 0)
    let wheel = LoadingWheelView()
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var geoButton: UIButton!
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var largeWeatherIcon: UIImageView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherDetailTableView: UITableView!
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(with: viewModel)
        self.prepareTableViews()
        wheel.modalPresentationStyle = .overFullScreen
    }
    
    // MARK: - Prepare
    private func prepareTableViews() {
        
        self.dateLabel.text = DateService.shared.dayFromUnixTime(time: 0, dateCase: .full)
        // Detail Weather
        weatherDetailTableView.rx.setDelegate(self).disposed(by: viewModel.bag)
        weatherDetailTableView.register(UINib(nibName: "WeatherDetailsTableViewCell", bundle: nil),
                                        forCellReuseIdentifier: "weatherDetailCell")
        // Hourly
        hourlyWeatherCollectionView.rx.setDelegate(self).disposed(by: viewModel.bag)
        hourlyWeatherCollectionView.register(UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil),
                                             forCellWithReuseIdentifier: "HourlyWeatherCollectionViewCell")
        // Daily
        dailyWeatherTableView.rx.setDelegate(self).disposed(by: viewModel.bag)
        dailyWeatherTableView.register(UINib(nibName: "DailyWeatherCell", bundle: nil),
                                       forCellReuseIdentifier: "DailyWeatherCell")
    }
    
    // MARK: - RxBinds
    private func bind(with viewModel: MainViewModel) {
        // MARK: - Input
        let input = MainViewModel.Input(geoTapped: self.geoButton.rx.tap.asDriver(), cityName: self.cityName, coordinates: self.coordinates, weatherDay: self.weatherDay)
        let output = viewModel.transform(input: input)
        
        self.cityName.subscribe(onNext: { city in
            self.currentCityName.text = city
        }).disposed(by: bag)
        self.cityName.onNext("Одесса")
        
        // MARK: - Buttons
        self.geoButton.rx.tap.subscribe(onNext: {
            self.present(CitySelectorView(selectedCity: { city in
                self.cityName.onNext(city)
            }), animated: true)
        }).disposed(by: bag)
        
        self.mapButton.rx.tap.subscribe(onNext: {
            self.present(WeatherMapView(latLon: self.latLon,
                                        selectedCoordinates: { lat, lon in
                let latLonYo = Coordinates(lat: lat, lon: lon)
                self.coordinates.onNext(latLonYo)
            }) ,animated: true)
        }).disposed(by: bag)
        
        // MARK: - Output
        // Detail Weather
        output.weatherModel.bind(to: weatherDetailTableView.rx.items(cellIdentifier: "weatherDetailCell", cellType: WeatherDetailsTableViewCell.self)) { row, item, cell in
            cell.bind(model: item)
        }.disposed(by: viewModel.bag)
        
        // Hourly RX
        output.hourlyWeatherModel.bind(to: hourlyWeatherCollectionView.rx.items(cellIdentifier: "HourlyWeatherCollectionViewCell", cellType: HourlyWeatherCollectionViewCell.self)) { row, item, cell in
            cell.bind(model: item)
        }.disposed(by: viewModel.bag)
        
        // Daily RX
        output.dailyWeatherModel.bind(to: dailyWeatherTableView.rx.items(cellIdentifier: "DailyWeatherCell", cellType: DailyWeatherCell.self)) { row, item, cell in
            cell.selectionStyle = .none
            cell.bind(model: item)
        }.disposed(by: viewModel.bag)
        
        // Weather Icon RX
        output.weatherIcon.subscribe(onNext: { icon in
            self.largeWeatherIcon.image = UIImage(systemName: icon)
        }).disposed(by: bag)
        
        output.latLon.subscribe(onNext: { latLon in
            self.latLon = latLon
        }).disposed(by: bag)
        
        output.cityName.subscribe(onNext: { cityName in
            self.currentCityName.text = cityName
        }).disposed(by: bag)
        
        output.loading.subscribe(onNext: { state in
            switch state {
            case .start:
                self.present(self.wheel, animated: false, completion: nil)
            case .stop:
                self.wheel.dismiss(animated: false, completion: nil)
            }
        }).disposed(by: bag)
        
        // TableView tapped RX
        dailyWeatherTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.dailyWeatherTableView.cellForRow(at: indexPath)  as? DailyWeatherCell
                if let model = cell?.model {
                    self?.weatherDay.onNext(viewModel.generateModelFrom(model: model))
                    self?.dateLabel.text = DateService.shared.dayFromUnixTime(time: model.day, dateCase: .full)
                }
            }).disposed(by: bag)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (tableView.dequeueReusableCell(withIdentifier: "weatherDetailCell") != nil) == true {
            return 40
        } else {
            return 80
        }
    }
}

