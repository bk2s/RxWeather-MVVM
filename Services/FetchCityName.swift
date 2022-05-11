//
//  FetchCityName.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 11.05.2022.
//

import Foundation

struct FetchCityName {
    
    func fetchCity(predict: String, completion: @escaping (_ cities: Autocomplete) -> ()) {
        print(predict)
        guard let url = URL.urlForAutocomplete(pred: predict) else { print("lol"); return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, responce, error in
            if error == nil {
                let decoder = JSONDecoder()
                if let safeData = data {
                    do {
                        let results = try decoder.decode(Autocomplete.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(results)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
}
