//
//  WeatherTableViewController.swift
//  WeatherReport
//
//  Created by Raghvendra on 15/11/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import UIKit

//Comment :WeatherTableViewController to show tableview containing city and there temperature.
class WeatherTableViewController: UITableViewController {
    
    var cityList = [String]()
    var temperatureOfCityFromList = [Int]()
    var cityId = ["4163971", "2147714", "2174003"]
    var responseJSONArray = [[String : AnyObject]]()
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Comment :Code to show activity indicator to show that page is processing data. It start showing indicator by calling startAnimating method.
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView  (activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.color = UIColor .magenta
        indicator.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        indicator.bringSubview(toFront: self.view)
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        //Comment :Imageview to show image backgroung image on screen.
        let image = #imageLiteral(resourceName: "weather3")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        tableView.backgroundView = imageView
        
        //Comment :Request to get data for 3 cities from server
        self.getLocationDetails(cityId: self.cityId[0])
        self.getLocationDetails(cityId: self.cityId[1])
        self.getLocationDetails(cityId: self.cityId[2])
        
        //Comment :Stop showing activity indicator as data is loaded into tableview.
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        
    }
    
    //Delegate Method: Delegate Method of table view. it is showing number of sections tableview will show.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityList.count
    }
    
    //Delegate Method: Delegate Method of table view. It will be called when user will tap on a cell.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Comment :This code will assign values to the variable of presenting view controller i.e WeatherDetailsViewController.It will parse the JSON object one by one and assign value to the variables of other view controller
        let cityWeatherVC = self.storyboard?.instantiateViewController(withIdentifier: "AlternateViewController") as! WeatherDetailsViewController
        
        let jsonObjectToPass = responseJSONArray[indexPath.row]
        let mainFromJSONcopy = jsonObjectToPass["main"] as? [String:AnyObject]
        let windFromJSONcopy = jsonObjectToPass["wind"] as? [String:AnyObject]
        
        let currentTemperatureToPass = mainFromJSONcopy!["temp"] as? Double
        let maxTemperatureToPass = mainFromJSONcopy!["temp_max"] as? Double
        let minTemperatureToPass = mainFromJSONcopy!["temp_min"] as? Double
        let windSpeedToPass = windFromJSONcopy!["speed"] as? Double
        
        cityWeatherVC.currentTemperature = String(format:"%.2f", currentTemperatureToPass!)
        cityWeatherVC.maximumTemperature = String(format:"%.2f", maxTemperatureToPass!)
        cityWeatherVC.minimumTemperature = String(format:"%.2f", minTemperatureToPass!)
        cityWeatherVC.humidity = mainFromJSONcopy!["humidity"] as? Int
        cityWeatherVC.windSpeed = String(format:"%.2f", windSpeedToPass!)
        cityWeatherVC.cityName = jsonObjectToPass["name"] as? String
        self.present(cityWeatherVC, animated: true, completion: nil)
        
    }
    
    //Delegate Method: Delegate Method of table view. It will assign values to the UITableViewCell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherOfCityCell", for: indexPath) as! WeatherTableViewCell
        let cityName = cityList[indexPath.row]
        let cityTemperature = temperatureOfCityFromList[indexPath.row]
        cell.cityNameLabel.text = cityName
        cell.currentTemperatureLabel.text = String(cityTemperature) + "°C"
        cell.layer.cornerRadius =  10.0
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        return cell
        
    }
    
    //Delegate Method: Delegate Method of table view. It will show number of sections tableview will contain.
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //User Defined Method : This method will make request by creating urlRequest. urlRequest will be created by using cityId and appKey. Response will be collected in an dictionary array named as 'responseJSONArray'. At the same time it is assigning to other arrays of city and temperature to show into table. On completion of dataTask resume action will be peformed.
    func getLocationDetails(cityId :String){
        
        // Comment: Use your api key over here.
        let appKey = ""
        let initialURL : String = "http://api.openweathermap.org/data/2.5/weather?id=\(cityId)&units=metric&APPID=\(appKey)"
        
        guard let url = URL(string: initialURL) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest){
            (data, response, error) in
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let responseJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                self.responseJSONArray.append(responseJSON)
                DispatchQueue.main.async{
                    let mainFromJSON = responseJSON["main"] as? [String:AnyObject]
                    let cityNameFromJSON = responseJSON["name"] as? String
                    let temperatureFromJSON = (mainFromJSON!["temp"] as? Double)?.rounded()
                    self.cityList.append(cityNameFromJSON!)
                    self.temperatureOfCityFromList.append(Int(temperatureFromJSON!))
                    self.tableView.reloadData()
                }
                
            }catch{
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}

// User Defined Class : Class holding properties of a WeatherTableViewCell
class WeatherTableViewCell: UITableViewCell{
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
}

