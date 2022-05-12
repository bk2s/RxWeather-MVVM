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

class WeatherMapView: UIViewController, MKMapViewDelegate {

    var selectedCoordinates: ((Double, Double) -> Void)?
    var bag = DisposeBag()
    var currentCity: PublishSubject<String>?
    var latLon: LatLon?
    var once: Bool = true
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var weatherTextField: UITextField!
    @IBOutlet weak var weatherMap: MKMapView!
    
    convenience init(currentCity: PublishSubject<String>,
                     latLon: LatLon?,
                     selectedCoordinates: @escaping (Double, Double) -> Void) {
        self.init()
        self.selectedCoordinates = selectedCoordinates
        self.currentCity = currentCity
        self.latLon = latLon
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherMap.delegate = self
        
       // addNewAnnotationPin(lat: 46.4775, lon: 30.7326)
        
//        self.currentCity?.subscribe(onNext: { city in
//            print(">>>> currentCity", city)
//            self.weatherTextField.placeholder = city
//        }).disposed(by: bag)
        
        self.addNewAnnotationPin(lat: self.latLon?.lat ?? 0, lon: self.latLon?.lon ?? 0)

        self.weatherMap.showAnnotations(self.weatherMap.annotations, animated: true)
        self.weatherMap.cameraZoomRange = .init(minCenterCoordinateDistance: 100000)

        
        self.backButton.rx.tap.subscribe(onNext: { _ in

            //self.dismiss(animated: true)
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
            pinView?.canShowCallout = true
            pinView?.isDraggable = true
            
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MyPointAnnotation {
            if let selectedAnnotation = view.annotation as? MyPointAnnotation {
                if let id = selectedAnnotation.identifier {
                    for pin in mapView.annotations as! [MyPointAnnotation] {
                        if let myIdentifier = pin.identifier {
                            if myIdentifier == id {
                               // self.selectedCoordinates?(pin.lat, pin.lon)
                                print(">>>> PIN LAT", pin.lat ?? 0)
                                print(">>>> PIN LON", pin.lon ?? 0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for touch in touches {
        let touchPoint = touch.location(in: weatherMap)
        let location = weatherMap.convert(touchPoint, toCoordinateFrom: weatherMap)
        self.latLon?.lon = location.longitude
        self.latLon?.lat = location.latitude
        print ("\(location.latitude), \(location.longitude)")
    }}
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         if overlay is MKPolygon {
             let polygonView = MKPolygonRenderer(overlay: overlay)
             polygonView.strokeColor = UIColor.black
             polygonView.lineWidth = 0.5
             return polygonView
         }
         return MKPolylineRenderer()
     }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        switch newState {
        case .starting:
            view.dragState = .dragging
        case .ending, .canceling:
            view.dragState = .none
        default: break
        }
    }
    
    
    func addNewAnnotationPin(lat: Double, lon: Double) {
        let myPin = MyPointAnnotation()
        myPin.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
//        myPin.title = title
//        myPin.subtitle = subTitle
        myPin.identifier = UUID().uuidString
        myPin.lat = lat
        myPin.lon = lon
        self.weatherMap.addAnnotation(myPin)
    }
}
