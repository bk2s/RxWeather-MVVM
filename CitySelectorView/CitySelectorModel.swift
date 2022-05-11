//
//  CitySelectorModel.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import Foundation
import RxSwift

class CitySelectorModel: ViewModel {
       
    public let bag = DisposeBag()
    private let cn = FetchCityName()

    func transform(input: Input) -> Output {
        <#code#>
    }
    
    // MARK: - Input&Output
    struct Input {
        let predict: PublishSubject<String>
    }
    
    struct Output {
        let cityNames: PublishSubject<[String]>
    }
    
}
