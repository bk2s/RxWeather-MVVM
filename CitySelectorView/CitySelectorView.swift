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
    var viewModel = CitySelectorModel()
    var predict = PublishSubject<String>()

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
        self.bind(with: viewModel)
    }

    // MARK: - RxBinds
    
    func bind(with model: CitySelectorModel) {
        let input = CitySelectorModel.Input(predict: self.predict)
        let output =  model.transform(input: input)
        
        // Observe SearchField RX
        self.searchField.rx.value.delay(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { city in
                if let city = city {
                    self.predict.onNext(city)
                }
            }).disposed(by: bag)
        
        // Buttons
        self.backButton.rx.tap.subscribe(onNext: { _ in
            self.dismiss(animated: true)
        }).disposed(by: bag)
        
        self.searchButton.rx.tap.subscribe(onNext: { _ in
            if let city = self.searchField.text {
                self.selectedCity?(city)
            }
            self.dismiss(animated: true)
        }).disposed(by: bag)
        
        // TableView RX
        output.cityNames.bind(to: citiesTableView.rx.items) {
            (tableView: UITableView, index: Int, element: String) in
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = element
            return cell
          }.disposed(by: bag)
        
        // TableView tapped RX
        citiesTableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
              let cell = self?.citiesTableView.cellForRow(at: indexPath) // as? NameOfCell
              if let city = cell?.textLabel?.text {
              self?.selectedCity?(city)
                  self?.dismiss(animated: true)
              }
          }).disposed(by: bag)
    }
}
