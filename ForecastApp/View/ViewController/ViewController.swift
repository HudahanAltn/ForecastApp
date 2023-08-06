//
//  ViewController.swift
//  ForecastApp
//
//  Created by Hüdahan Altun
//

import UIKit
import CoreLocation
class ViewController: UIViewController {

    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var temperatureUnderline: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    private let locationManagerr:CLLocationManager = CLLocationManager()
    
    private var viewModelHome = ViewModelVC()
   
    private var sevenDaysWeatherCondition:[Daily] = [Daily]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        UIFeatures().showTodayName(todayLabel: todayLabel)
        UIFeatures().setLocationManager(locationManager: locationManagerr, viewController: self)
        UIFeatures().setTableViewFeatures(tableView: weatherTableView, viewController: self)
        UIFeatures().showAnimation(temperatureUnderline: temperatureUnderline, weatherConditionImageView: weatherConditionImageView)

    }

}

//MARK: - TableView Protokolleri
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sevenDaysWeatherCondition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let weatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell",for:indexPath) as! WeatherTableViewCell

        UITableViewCellFeatures().setWeatherCell(weatherConditions: sevenDaysWeatherCondition, cell: weatherCell, indexPath: indexPath)

        UITableViewCellFeatures().showCellAnimation(cell: weatherCell)

        return weatherCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // Hücre arka plan rengini şeffaf yap
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let rowHeight:CGFloat = tableView.frame.size.height/7
        return rowHeight
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Hücre seçildiğinde çalışır
            tableView.deselectRow(at: indexPath, animated: true)
        }
}


extension ViewController{
    
    private func getCurrentWeatherCondition(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        //Günlük Hava Durumu
        viewModelHome.loadDataWithLocation(latitude: latitude, longitude: longitude)// günlük hava durumu bilgilerini aldık

        viewModelHome.receivedWeather.bind{// verileri UI'a geçirdik
            
            [weak self] value in //value WeatherModel cinslidir.
            
            DispatchQueue.main.async {
                
                let cityString = value?.cityname
                if let range = cityString!.range(of: " "){
                    let substring = cityString![..<range.lowerBound]
                    self?.cityLabel.text = String(substring)
                }else{
                    
                    self?.cityLabel.text = cityString
                }
                self?.weatherConditionImageView.image = UIImage(systemName: value!.conditionName)
//                self?.temperatureLabel.text = String((value?.temperatureString.prefix(2))!)
                self?.temperatureLabel.text = value?.temperatureString
                
                value?.getIcon(iconCode: value!.conditionName){ data in
                    DispatchQueue.main.async {
                        self?.weatherConditionImageView.image = UIImage(data: data!)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    private func getSevenDaysWeatherCondition(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        viewModelHome.loadSevenDaysWeatherDataWithLocaiton(latitude: latitude, longitude: longitude)
        
        viewModelHome.receivedSevenDaysWeather.bind{
            
            [ weak self] value in // Value Daily cinsindedir
            
            DispatchQueue.main.async {
                
                var i = 1
                let maxCount = 8

                while i < maxCount {
                    i += 1

                    self!.sevenDaysWeatherCondition.append(value!.daily[i-1])//her günü alıp listeye ekleriz.
                    self!.weatherTableView.reloadData()
                }
            }

        }
    }
}

extension ViewController:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //coreLocation birkaç defa konum almaya çalışarak en doğru konum bilgisini elde etmeye çalışır.böylece bütün konumların bulunduğu "locations" dizisi oluşturulur.dizinin en son elemanı en doğru konumu verir
        if let locationInf = locations.last {// konumu aldık
            
            locationManagerr.stopUpdatingLocation()
            let latitude = locationInf.coordinate.latitude
            let longitude = locationInf.coordinate.longitude
        
            getCurrentWeatherCondition(latitude: latitude, longitude: longitude)//konuma bağlı o günkü hava durumunu getir
      
            getSevenDaysWeatherCondition(latitude: latitude, longitude: longitude)//konuma bağlı 7 günlük hava durumunu getir
        }
    
    }
 
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("konum hatası")
        print(error)
    }
    
    
}

