//
//  CitySelectorView.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 02.05.2022.
//

import UIKit
import RxSwift
import RxCocoa

class CitySelectorView: UIViewController {
    
    let bag = DisposeBag()
    var selectedCity: ((String) -> Void)?

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var citiesTableView: UITableView!
    
    convenience init(selectedCity: @escaping (String) -> Void) {
        self.init()
        self.selectedCity = selectedCity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
            // Заготовка для отслеживания введенных городов
        
//        self.searchField.rx.controlEvent(.editingDidEndOnExit)
//            .map { self.searchField.text }
//            .subscribe(onNext: { city in
//                if let city = city {
//                self.selectedCity?(city)
//                }
//            }).disposed(by: bag)
        
        /*- Cупер полезная хрень
        self.cityNameTextField.rx.value.delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { value in
                if value != "" {
                    FetchWeather.fetchWeather(by: value!)
                }
                
            }).disposed(by: bag)
        -*/
        

        self.backButton.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true)
        }).disposed(by: bag)
        
        self.searchButton.rx.tap.subscribe(onNext: { _ in
            if let city = self.searchField.text {
                self.selectedCity?(city)
            }
            self.dismiss(animated: true)
        }).disposed(by: bag)
        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

}
