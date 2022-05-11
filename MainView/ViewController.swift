//
//  ViewController.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 13.04.2022.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UIScrollViewDelegate {
    
    var viewModel = MainViewModel()
    var bag = DisposeBag()
    public var cityName = PublishSubject<String>()

    @IBOutlet weak var geoButton: UIButton!
    @IBOutlet weak var currentCityName: UILabel!
    @IBOutlet weak var largeWeatherIcon: UIImageView!
    @IBOutlet weak var hourlyWeatherCollectionView: UICollectionView!
    @IBOutlet weak var weatherDetailTableView: UITableView!
    @IBOutlet weak var dailyWeatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bind(with: viewModel)
        self.cityName.subscribe(onNext: { city in
            self.currentCityName.text = city
        }).disposed(by: bag)
        self.cityName.onNext("Одесса")
        self.prepareTableViews()
        
        self.geoButton.rx.tap.subscribe(onNext: {
            self.present(CitySelectorView(selectedCity: { city in
                self.cityName.onNext(city)
            }), animated: true)
        }).disposed(by: bag)
    }
    
    // MARK: - Prepare
    private func prepareTableViews() {
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
        let input = MainViewModel.Input(geoTapped: self.geoButton.rx.tap.asDriver(), cityName: self.cityName)
        let output = viewModel.transform(input: input)
        
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
            cell.bind(model: item)
        }.disposed(by: viewModel.bag)
        
        // Weather Icon RX
        output.weatherIcon.subscribe(onNext: { icon in self.largeWeatherIcon.image = UIImage(systemName: icon); print(">>>>", icon) }).disposed(by: bag)

//        output.weatherModel.subscribe(onNext: { weather in
//        }).disposed(by: bag)
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

