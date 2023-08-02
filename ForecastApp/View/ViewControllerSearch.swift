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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewFeatures()
        
        citySearchBar.delegate = self
        
        citySearchBar.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
    }
    

  
}

extension ViewControllerSearch{
    
    private func setTableViewFeatures(){
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        
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
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell",for:indexPath) as! CityTableViewCell
        
        cell.cityLabel.text = "İstanbul"
        cell.weatherConditionImageView.image = UIImage(systemName: "sun.max")
        cell.temperatureLabel.text = "20.4"
        
        return cell
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
extension ViewControllerSearch:UISearchBarDelegate{
    
    
}
