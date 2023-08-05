//
//  SevenDayWeatherConditionViewController.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 3.08.2023.
//

import UIKit
import CoreLocation

class searchedCityViewController: UIViewController {

    @IBOutlet weak var cityLAbel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var temperatureUnderline: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    private var searchedCityCondition:[Daily] = [Daily]()

    
    var searchedCityWeather:WeatherModel?
    
    var viewModelSearchedVC = ViewModelVC()
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCurrentWeather()
        setTableViewFeatures()
        showAnimation()
    }

  

}
extension searchedCityViewController{
    
    private func showAnimation(){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {

            self.temperatureUnderline.alpha = 0
            
            self.weatherConditionImageView.transform = CGAffineTransform(translationX: 8, y: 0)
            
            self.weatherConditionImageView.alpha = 1
            
            self.temperatureUnderline.alpha = 1
            
        }, completion: nil)
        
        
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
    
    private func loadCurrentWeather(){
        
        if let weather = searchedCityWeather{
            
            let cityString = weather.cityname
            if let range = cityString.range(of: " "){
                let substring = cityString[..<range.lowerBound]
                self.cityLAbel.text = String(substring)
            }else{
                
                self.cityLAbel.text = cityString
            }
            showTodayName()
            weather.getIcon(iconCode: weather.conditionName){ [weak self]
                data in
                
                DispatchQueue.main.async {
                    self!.weatherConditionImageView.image = UIImage(data: data!)
                }
               
            }
            getSevenDaysWeatherCondition(latitude: weather.latitude, longitude: weather.longitude)
            temperatureLabel.text = weather.temperatureString
            
        }

    }
  
    private func showTodayNameFromUnixDate(indexPath:IndexPath)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: TimeInterval(searchedCityCondition[indexPath.row].dt))
        let dayName = dateFormatter.string(from: date)
        
        return dayName
    }
    
    private func showTodayName(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = Date()
        todayLabel.text = dateFormatter.string(from: today)
        
    }
}

extension searchedCityViewController{
    
    private func showCellAnimation(cell:SearchedCityTableViewCell){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {
            cell.maxTempUnderline.alpha = 0
            cell.minTempUnderline.alpha = 0
            cell.weatherConditionImageView.transform = CGAffineTransform(translationX: 4, y: 0)
            
            cell.weatherConditionImageView.alpha = 1
            cell.maxTempUnderline.alpha = 1
            cell.minTempUnderline.alpha = 1
            
        }, completion: nil)
        
    }
    
    private func setWeatherCell(cell:SearchedCityTableViewCell,indexPath:IndexPath){
        
        var day:String{
            return showTodayNameFromUnixDate(indexPath: indexPath)
        }
        
        cell.dayLabel.text = day
        
        self.searchedCityCondition[indexPath.row].weather[0].getIcon(iconCode: self.searchedCityCondition[indexPath.row].weather[0].icon){
             
             data in
            DispatchQueue.main.async {
                cell.weatherConditionImageView.image = UIImage(data: data!)
            }
            
         }

        cell.minTemperature.text = String(format: "%.1f",searchedCityCondition[indexPath.row].temp.min)
        cell.maxTemperature.text = String(format: "%.1f",searchedCityCondition[indexPath.row].temp.max)
    }
}
extension searchedCityViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchedCityCondition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let weatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "searchedCityCell",for:indexPath) as! SearchedCityTableViewCell

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

extension searchedCityViewController{
    
    private func getSevenDaysWeatherCondition(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        
        viewModelSearchedVC.loadSevenDaysWeatherDataWithLocaiton(latitude: latitude, longitude: longitude)
        
        viewModelSearchedVC.receivedSevenDaysWeather.bind{
            
            [ weak self] value in // Value Daily cinsindedir
            
            DispatchQueue.main.async {
                
                var i = 1
                let maxCount = 8

                while i < maxCount {
                    i += 1

                    self!.searchedCityCondition.append(value!.daily[i-1])//her günü alıp listeye ekleriz.
                    self!.weatherTableView.reloadData()
                }
            }

        }
    }
}
