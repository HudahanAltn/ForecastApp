//
//  ViewControllerSearch.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//

import UIKit

class ViewControllerSearch: UIViewController {

    @IBOutlet weak var citySearchBar: UISearchBar!
    
    @IBOutlet weak var cityTableView: UITableView!
    
    private var viewModelSearch = ViewModelVC()
    
    private var searchedWeather:WeatherModel?
    
    private var aramaYapılıyorMu:Bool = false
    
    private var aramayapıldı:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewFeatures()
        setSearchBarFeatures()
        
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let weather = sender as? WeatherModel{
            
            if segue.identifier == "searchtoSevenDays"{
                
                let sevenDaysVC = segue.destination as! ViewControllerSearchedCity
                
                sevenDaysVC.searchedCityWeather = weather
            }
            
        }
    }

}

extension ViewControllerSearch{
    
    private func setSearchBarFeatures(){
        citySearchBar.delegate = self
        citySearchBar.keyboardType = .default
        citySearchBar.returnKeyType = .continue
        citySearchBar.autocapitalizationType = .none
        citySearchBar.autocorrectionType = .no
        citySearchBar.barTintColor = UIColor(rgb: 0x5CC2F2)
        citySearchBar.backgroundImage = UIImage()
    }
    private func setTableViewFeatures(){
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        
        cityTableView.alpha = 0
        cityTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        cityTableView.separatorStyle = .singleLine
        cityTableView.separatorColor = .white
        cityTableView.backgroundView = nil
    }
  
}
extension ViewControllerSearch:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if aramaYapılıyorMu{
            return 1
            
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if aramaYapılıyorMu{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell",for:indexPath) as! CityTableViewCell
          
            let cityString = searchedWeather?.cityname
            if let range = cityString!.range(of: " "){
                let substring = cityString![..<range.lowerBound]
                cell.cityLabel.text = String(substring)
            }else{
                
                cell.cityLabel.text = cityString
            }
            
//            cell.cityLabel.text = searchedWeather?.cityname
            searchedWeather?.getIcon(iconCode: searchedWeather!.conditionName){

                value in
                DispatchQueue.main.async {
                    cell.weatherConditionImageView.image = UIImage(data: value!)

                }
            }
            cell.temperatureLabel.text = searchedWeather?.temperatureString
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell",for:indexPath) as! CityTableViewCell
            let noWeather:WeatherModel = WeatherModel()
            cell.cityLabel.text = noWeather.cityname
            cell.weatherConditionImageView.image = nil
            cell.temperatureLabel.text = ""
            
       
            return cell
        }
      
     
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
        
        let rowHeight:CGFloat = tableView.frame.size.height/7.5
        
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "searchtoSevenDays", sender: searchedWeather)
    }
    
}
extension ViewControllerSearch:UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {// her metin değiştiğinde tetiklenir.
        
        if citySearchBar.text == ""{ // searchBar 'a yazdıklarımızı silince
            
            aramaYapılıyorMu = false// arama artık yapılmıyordur
            
            cityTableView.alpha = 0
            
            self.cityTableView.reloadData()
            
        }
        else{//arama yapılıyor
            
            aramaYapılıyorMu = true
            cityTableView.alpha = 1
            
            if let cityName = searchBar.text{
     
                viewModelSearch.loadDataWithCityName(cityName: cityName)
                viewModelSearch.receivedWeather.bind{
                    
                    [weak self] value in
                    
            
                    DispatchQueue.main.async {
                        self!.searchedWeather = value
                        self!.cityTableView.reloadData()
                    }
                   
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}


