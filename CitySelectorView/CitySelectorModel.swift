//
//  CitySelectorModel.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import Foundation
import RxSwift
import RxCocoa

class CitySelectorModel: ViewModel {
    
    public let bag = DisposeBag()
    private let cn = FetchCityName()
    private var citiesArray: [String] = []

    
    func transform(input: Input) -> Output {
        let cityNames = PublishSubject<[String]>()
        
        input.predict.bind { predict in
            self.cn.fetchCity(predict: predict) { cities in
                self.citiesArray = []
               _ = cities.compactMap { city in
                    if let cityName = city.address?.name {
                    //cityNames.onNext([cityName])
                        self.citiesArray.append(cityName)
                    }
                }
                cityNames.onNext(self.citiesArray.uniqued().sorted())
            }
        }.disposed(by: bag)
        
        return Output(cityNames: cityNames)
    }
    
    // MARK: - Input&Output
    struct Input {
        let predict: PublishSubject<String>
    }
    
    struct Output {
        let cityNames: PublishSubject<[String]>
    }
    
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
