//
//  SevenDayWeatherConditionViewController.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 3.08.2023.
//

import UIKit
import CoreLocation


class ViewControllerSearchedCity: UIViewController {

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


        UIFeatures().showTodayName(todayLabel: todayLabel)
        UIFeatures().setTableViewFeatures(tableView: weatherTableView, viewController: self)
        UIFeatures().showAnimation(temperatureUnderline: temperatureUnderline, weatherConditionImageView: weatherConditionImageView)
    }

  

}
extension ViewControllerSearchedCity{
 
    private func loadCurrentWeather(){
        
        if let weather = searchedCityWeather{
            
            let cityString = weather.cityname
            if let range = cityString.range(of: " "){
                let substring = cityString[..<range.lowerBound]
                self.cityLAbel.text = String(substring)
            }else{
                
                self.cityLAbel.text = cityString
            }
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

}

extension ViewControllerSearchedCity:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchedCityCondition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let weatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "searchedCityCell",for:indexPath) as! SearchedCityTableViewCell

        UITableViewCellFeatures().setWeatherCell(weatherConditions: searchedCityCondition, cell: weatherCell, indexPath: indexPath)
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

extension ViewControllerSearchedCity{
    
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
