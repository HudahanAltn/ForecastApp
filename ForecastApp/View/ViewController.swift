//
//  ViewController.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
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
    
    private var dayNames = ["Pazartesi","Salı","Çarşamba","Perşembe","Cuma","Cumartesi","Pazar"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showTodayName()
        setLocationManager()
        setTableViewFeatures()
        showAnimation()
    }

}

extension ViewController{
    
    private func showTodayNameFromUnixDate(indexPath:IndexPath)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: TimeInterval(sevenDaysWeatherCondition[indexPath.row].dt))
        let dayName = dateFormatter.string(from: date)
        
        return dayName
    }
    
    private func showTodayName(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = Date()
        todayLabel.text = dateFormatter.string(from: today)
        
    }
    
    private func setLocationManager(){
        
        locationManagerr.delegate = self
        //        locationManagerr.desiredAccuracy = kCLLocationAccuracyBest
        locationManagerr.requestWhenInUseAuthorization() // konum kullanma izni
        locationManagerr.requestLocation() // 1 kerelik konum alma talebi (sürekli takio gerektirmeyen uyg iiçin) (sürekli konum verisi almak için startUpdatingLocation() kullanılır)
        
    }
    private func setTableViewFeatures(){
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        weatherTableView.frame.size.height = UIScreen.main.bounds.height/2
        weatherTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        weatherTableView.separatorStyle = .singleLine
        weatherTableView.separatorColor = .white
        weatherTableView.backgroundView = nil
    }
  
    
    private func getTime()->Int{
        
        let currentDate = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: currentDate)
        let hour = calendar.component(.hour, from: currentDate)
        
        let time = hour*60 + minutes
        
        return time
    }
    
    private func showAnimation(){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {

            self.temperatureUnderline.alpha = 0
            
            self.weatherConditionImageView.transform = CGAffineTransform(translationX: 8, y: 0)
            
            self.weatherConditionImageView.alpha = 1
            
            self.temperatureUnderline.alpha = 1
            
        }, completion: nil)
        
        
    }
}

extension ViewController{
    
    private func showCellAnimation(cell:WeatherTableViewCell){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {
            cell.maxTempUnderline.alpha = 0
            cell.minTempUnderline.alpha = 0
            cell.weatherConditionImageView.transform = CGAffineTransform(translationX: 4, y: 0)
            
            cell.weatherConditionImageView.alpha = 1
            cell.maxTempUnderline.alpha = 1
            cell.minTempUnderline.alpha = 1
            
        }, completion: nil)
        
    }
    
    private func setWeatherCell(cell:WeatherTableViewCell,indexPath:IndexPath){
        
        var day:String{
            return showTodayNameFromUnixDate(indexPath: indexPath)
        }
        
        cell.dayLabel.text = day
        
        self.sevenDaysWeatherCondition[indexPath.row].weather[0].getIcon(iconCode: self.sevenDaysWeatherCondition[indexPath.row].weather[0].icon){
             
             data in
            DispatchQueue.main.async {
                cell.weatherConditionImageView.image = UIImage(data: data!)
            }
            
         }

        cell.minTemperature.text = String(format: "%.1f",sevenDaysWeatherCondition[indexPath.row].temp.min)
        cell.maxTemperature.text = String(format: "%.1f",sevenDaysWeatherCondition[indexPath.row].temp.max)
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

        setWeatherCell(cell: weatherCell, indexPath: indexPath)
        showCellAnimation(cell: weatherCell)
        
        return weatherCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       // Hücre arka plan rengini şeffaf yap
        cell.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
       // Header arka plan rengini şeffaf yap
       view.backgroundColor = UIColor.clear
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
       // Footer arka plan rengini şeffaf yap
       view.backgroundColor = UIColor.clear
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
        //coreLocation birkaç defa konum almaya çalışarak en doğru konum bilgisini elde etmeye çalışır.böylece bütün konumlaırn bulunduğu "locations" dizisi oluşturulur.dizinin en son elemanı en doğru konumu verir
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

