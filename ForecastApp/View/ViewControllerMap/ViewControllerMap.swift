//
//  ViewControllerMap.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 5.08.2023.
//

import UIKit
import MapKit
import CoreLocation

class ViewControllerMap: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager:CLLocationManager = CLLocationManager()
    
    var weatherModel:WeatherModel?
    var annotation = MKPointAnnotation()
    var isAnnotationAvaliable:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMap()
        configureLocationManager()
        addGestureRecognizer()
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let weather = sender as? WeatherModel{
            
            if segue.identifier == "mapToSearchedCity" {
                
                let VC = segue.destination as! ViewControllerSearchedCity
                VC.searchedCityWeather = weather
            }
        }
    }
    
}

extension ViewControllerMap{
    
    func configureMap(){
   
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
  
    }
    
    func configureLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //en iyi konumu al
        locationManager.requestWhenInUseAuthorization() // konumu alırken kullanıcıdan izin iste
        locationManager.startUpdatingLocation() // vc yüklenince konum almayı başlat
        
    }
    
    func addGestureRecognizer(){
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 0.5 //kullanıcı yer ekleemesi için 2sn haritaya basılı tutmalı
        mapView.addGestureRecognizer(gestureRecognizer) // basma fonksiyonunun haritaya ekledik
    }
}

extension ViewControllerMap:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude) // konum al
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // span yarat
        
        let region = MKCoordinateRegion(center: myLocation, span: span) // bölge yarat
        
        mapView.setRegion(region, animated: true) // bölge setle
      
    }
    
}

extension ViewControllerMap:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? { //map view üzerinde özel pin oluşturmaya yarayan fonksiyon.

        let reuseAnnID = "myAnnotation"//özel pin id ismi
        
        //pinimizi mapview e tanıtıyoruz
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseAnnID)
        
        if pinView == nil{ //eklenen pin dolu ise
            
            //pini map e ekliyoruz
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseAnnID)
            
            pinView?.canShowCallout = true //pin e özel butonlar eklemek istioyrsak true yapılır
            
            pinView?.tintColor = .red // pin buton rengi
            
            let button = UIButton(type: .detailDisclosure) //pine özel buton oluşturduk
            
            pinView?.rightCalloutAccessoryView = button //pine butonu aktardık
            
        }else{
            
            pinView?.annotation = annotation //pin normal
        }
        
        return pinView //pin return edilir
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {// kullanıcı özle pindeki information butonua tıklarsa ViewControllerSearchedCity sayfasına geçecek.
        
        performSegue(withIdentifier: "mapToSearchedCity", sender: weatherModel)
        
    }
}


extension ViewControllerMap{

    @objc func chooseLocation(gestureRecognizer:UILongPressGestureRecognizer){ //kullanıcı yeni yer eklemek için haritaya 1 sn  basması gerekiyor.Teyikleme fonksiyonu
        
       
        if gestureRecognizer.state == .began{ //kullanıcı haritaya bastıysa

            if isAnnotationAvaliable { //true ise demek haritada pin var
                
                mapView.removeAnnotation(annotation)
                isAnnotationAvaliable = false
                
            }else{
                
                let touchedPoint = gestureRecognizer.location(in: mapView) // kullanıcının bastığı noktayı alıypruz
                
                let touchedCoord = mapView.convert(touchedPoint, toCoordinateFrom: mapView) //bu noktayı konuma dönüştürüoyruz
                
                
                let choosenLatitude = touchedCoord.latitude
                let choosenLongitude = touchedCoord.longitude
                
             
                 //pin oluşturduk.bu pin seçilen yeri gösterecek
                let newAnnonation = MKPointAnnotation()
                
                annotation = newAnnonation
           
                newAnnonation.coordinate = touchedCoord // koordinatları pine yükledik
                
                WeatherManager().fetchWeatherConditionatUserLocation(latitude: choosenLatitude, longitude: choosenLongitude){ [ weak self]
                    weather in
                    
                    newAnnonation.title = weather?.cityname
                    
                    self?.weatherModel = WeatherModel(coditionID: weather!.conditionID, cityname: weather!.cityname, temperature: weather!.temperature, latitude: weather!.latitude, longitude: weather!.latitude)
                    
                }
                
                mapView.addAnnotation(newAnnonation)// pini map e ekledik
               
                annotation = newAnnonation
                
                isAnnotationAvaliable = true
            }
            
        }
    }
}
