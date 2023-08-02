//
//  ViewController.swift
//  ForecastApp
//
//  Created by Hüdahan Altun on 2.08.2023.
//

import UIKit

class ViewController: UIViewController {

    
    
    
    @IBOutlet weak var weatherConditionImageView: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var temperatureUnderline: UILabel!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setTableViewFeatures()
        
    }

    

}

extension ViewController{
    
    private func setTableViewFeatures(){
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        weatherTableView.frame.size.height = UIScreen.main.bounds.height/2
        weatherTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        weatherTableView.separatorStyle = .singleLine
        weatherTableView.separatorColor = .white
        weatherTableView.backgroundView = nil
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let weatherCell = weatherTableView.dequeueReusableCell(withIdentifier: "weatherCell",for:indexPath) as! WeatherTableViewCell
        
        weatherCell.dayLabel.text = "Pazartesi"
        weatherCell.weatherConditionImageView.image = UIImage(systemName: "sun.max")
        weatherCell.minTemperature.text = "10.4"
        weatherCell.maxTemperature.text = "20.4"
        
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
}
