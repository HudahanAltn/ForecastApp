//
//  UIFeatures.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 6.08.2023.
//

import Foundation
import UIKit
import CoreLocation

struct UIFeatures{//viewcontroller uı elemanlarının görsel setlenmesi için oluşturulan sınıf.
    
     func showTodayNameFromUnixDate(weatherConditions:[Daily],indexPath:IndexPath)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSince1970: TimeInterval(weatherConditions[indexPath.row].dt))
        let dayName = dateFormatter.string(from: date)
        
        return dayName
    }
    
     func showTodayName(todayLabel:UILabel){

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let today = Date()
        todayLabel.text = dateFormatter.string(from: today)

    }
    
     func setLocationManager(locationManager:CLLocationManager,viewController:UIViewController){
        
        locationManager.delegate = viewController as? any CLLocationManagerDelegate
        //        locationManagerr.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() // konum kullanma izni
        locationManager.requestLocation() // 1 kerelik konum alma talebi (sürekli takio gerektirmeyen uyg iiçin) (sürekli konum verisi almak için startUpdatingLocation() kullanılır)
        
    }
     func setTableViewFeatures(tableView:UITableView,viewController:UIViewController){
        
        tableView.delegate = viewController as? any UITableViewDelegate
        tableView.dataSource = viewController as? any UITableViewDataSource
        
        tableView.frame.size.height = UIScreen.main.bounds.height/2
        tableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .white
        tableView.backgroundView = nil
    }
  
     func showAnimation(temperatureUnderline:UILabel,weatherConditionImageView:UIImageView){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {

            temperatureUnderline.alpha = 0
            
            weatherConditionImageView.transform = CGAffineTransform(translationX: 8, y: 0)
            
            weatherConditionImageView.alpha = 1
            
            temperatureUnderline.alpha = 1
            
        }, completion: nil)
        
        
    }
    
}
