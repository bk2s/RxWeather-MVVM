//
//  WeatherMapView.swift
//  RxWeather MVVM
//
//  Created by  Stepanok Ivan on 12.05.2022.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa

class MyPointAnnotation: MKPointAnnotation {
    var identifier: String?
    var lat: Double!
    var lon: Double!
}

struct CityAndCoord {
    let cityName: String
    let lat: Double
    let lon: Double
}

class WeatherMapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var selectedCoordinates: ((Double, Double) -> Void)?
    var bag = DisposeBag()
    var latLon: LatLon?
    let locationManager = CLLocationManager()
    let regionInMeters = 10_00.00
    let myPin = MyPointAnnotation()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var weatherMap: MKMapView!
    @IBOutlet weak var userLocation: UIButton!
    
    convenience init(latLon: LatLon?,
                     selectedCoordinates: @escaping (Double, Double) -> Void) {
        self.init()
        self.selectedCoordinates = selectedCoordinates
        self.latLon = latLon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherMap.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        weatherMap.showsUserLocation = true
        self.locationManager.requestWhenInUseAuthorization()

        
        self.addNewAnnotationPin(lat: self.latLon?.lat ?? 0, lon: self.latLon?.lon ?? 0)

        self.weatherMap.showAnnotations(self.weatherMap.annotations, animated: true)
        self.weatherMap.cameraZoomRange = .init(minCenterCoordinateDistance: 100000)

        self.userLocation.rx.tap.subscribe(onNext: { _ in
            self.showUserLocation()
        }).disposed(by: bag)
        
        self.backButton.rx.tap.subscribe(onNext: { _ in

            self.dismiss(animated: true)
        }).disposed(by: bag)
        
        self.searchButton.rx.tap.subscribe(onNext: { _ in
                //self.selectedCoordinates?(12323,456456)
            if let lat = self.latLon?.lat, let lon = self.latLon?.lon {
            self.selectedCoordinates?(lat, lon)
            }
            self.dismiss(animated: true)
        }).disposed(by: bag)
        // Do any additional setup after loading the view.
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.red
            pinView?.canShowCallout = false
            pinView?.isDraggable = true
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        let touchPoint = touch.location(in: weatherMap)
        let location = weatherMap.convert(touchPoint, toCoordinateFrom: weatherMap)
        self.latLon?.lon = location.longitude
        self.latLon?.lat = location.latitude
        print ("\(location.latitude), \(location.longitude)")
    }}
    
    private func addNewAnnotationPin(lat: Double, lon: Double) {
        self.myPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        self.myPin.identifier = UUID().uuidString
        self.myPin.lat = lat
        self.myPin.lon = lon
        self.weatherMap.addAnnotation(myPin)
    }
    
    private func showUserLocation() {
         if let location = locationManager.location?.coordinate {
             let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
             self.myPin.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
             self.myPin.lat = location.latitude
             self.myPin.lon = location.longitude
             self.latLon = LatLon(lat: location.latitude, lon: location.longitude)
             weatherMap.setRegion(region, animated: true)
         }
     }
}
