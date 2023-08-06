//
//  UITableViewFeatures.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 6.08.2023.
//

import Foundation
import UIKit

struct UITableViewCellFeatures{//UITableviewCell UI elemanlarının görsel setlenmesi  ve çeşitli yapılandırmaların gerçekleştirilmesi için oluşturulan sınıf.
    
    
     func showCellAnimation(cell:WeatherTableViewCell){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {
            cell.maxTempUnderline.alpha = 0
            cell.minTempUnderline.alpha = 0
            cell.weatherConditionImageView.transform = CGAffineTransform(translationX: 4, y: 0)
            
            cell.weatherConditionImageView.alpha = 1
            cell.maxTempUnderline.alpha = 1
            cell.minTempUnderline.alpha = 1
            
        }, completion: nil)
        
    }
  
     func setWeatherCell(weatherConditions:[Daily],cell:WeatherTableViewCell,indexPath:IndexPath){
        
        var day:String{
            return  UIFeatures().showTodayNameFromUnixDate(weatherConditions: weatherConditions, indexPath: indexPath)
        }
        
        cell.dayLabel.text = day
        
        weatherConditions[indexPath.row].weather[0].getIcon(iconCode: weatherConditions[indexPath.row].weather[0].icon){
             
             data in
            DispatchQueue.main.async {
                cell.weatherConditionImageView.image = UIImage(data: data!)
            }
            
         }

        cell.minTemperature.text = String(format: "%.1f",weatherConditions[indexPath.row].temp.min)
        cell.maxTemperature.text = String(format: "%.1f",weatherConditions[indexPath.row].temp.max)
    }
    
    
     func showCellAnimation(cell:SearchedCityTableViewCell){
        
        UIView.animate(withDuration: 2 ,delay:0 ,options:[.repeat,.autoreverse],animations: {
            cell.maxTempUnderline.alpha = 0
            cell.minTempUnderline.alpha = 0
            cell.weatherConditionImageView.transform = CGAffineTransform(translationX: 4, y: 0)
            
            cell.weatherConditionImageView.alpha = 1
            cell.maxTempUnderline.alpha = 1
            cell.minTempUnderline.alpha = 1
            
        }, completion: nil)
        
    }
    
     func setWeatherCell(weatherConditions:[Daily],cell:SearchedCityTableViewCell,indexPath:IndexPath){
        
        var day:String{
            return UIFeatures().showTodayNameFromUnixDate(weatherConditions:weatherConditions,indexPath: indexPath)
        }
        
        cell.dayLabel.text = day
        
        weatherConditions[indexPath.row].weather[0].getIcon(iconCode: weatherConditions[indexPath.row].weather[0].icon){
             
             data in
            DispatchQueue.main.async {
                cell.weatherConditionImageView.image = UIImage(data: data!)
            }
            
         }

        cell.minTemperature.text = String(format: "%.1f",weatherConditions[indexPath.row].temp.min)
        cell.maxTemperature.text = String(format: "%.1f",weatherConditions[indexPath.row].temp.max)
    }
}
