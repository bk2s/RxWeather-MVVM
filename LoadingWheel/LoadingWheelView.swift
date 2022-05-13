//
//  LoadingWheelView.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 13.05.2022.
//

import UIKit

enum LoadingState {
    case start
    case stop
}

class LoadingWheelView: UIViewController {

    @IBOutlet weak var grayView: UIView! {
        didSet {
            self.grayView.layer.cornerRadius = 20
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("YO SHIT ON FIRE")
        // Do any additional setup after loading the view.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
