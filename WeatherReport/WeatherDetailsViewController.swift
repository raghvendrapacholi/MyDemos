//
//  WeatherDetailsViewController.swift
//  WeatherReport
//
//  Created by Raghvendra on 19/11/17.
//  Copyright © 2017 Raghvendra. All rights reserved.
//

import Foundation
import UIKit

//Comment : Class responsible to show detail of city weather. It has 2 methods --> viewDidLoad, BackButtonTapped. viewDidLoad will load the view while BackButtonTapped will dismiss the view presented from by weatherTableViewController.
class WeatherDetailsViewController : UIViewController{
    
    @IBOutlet weak var weatherBkgView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var cityName : String?
    var weatherType : String?
    var maximumTemperature : String!
    var minimumTemperature : String!
    var currentTemperature : String!
    var humidity : Int?
    var windSpeed : String?
    
    let gradient : CAGradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ImageView to create background of page. It is added as part of main view with given boundation and sent to back as it should be at last in page.
        let image = #imageLiteral(resourceName: "weather1")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(imageView)
        view.sendSubview(toBack: imageView)
        
        //        gradient.frame = weatherBkgView.bounds
        //        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        //It is subview to the imageView. Named as weatherBkgView. It will hold the weatherImageView which will display the current weather image on the page.
        weatherBkgView.layer.cornerRadius = 15.0
        weatherBkgView.clipsToBounds = true
        
        // As not getting the weather type in response of api so setting as 'unknown' image for weatherImageView. later on weatherImageView is added as subview of weatherBkgView.
        weatherImageView.image = #imageLiteral(resourceName: "unknown")
        weatherBkgView.addSubview(weatherImageView)
        
        // textcolor of all labels of storyboard is changed as 'White'.
        cityNameLabel.textColor = UIColor.white
        maximumTemperatureLabel.textColor = UIColor.white
        minimumTemperatureLabel.textColor = UIColor.white
        currentTemperatureLabel.textColor = UIColor.white
        humidityLabel.textColor = UIColor.white
        windSpeedLabel.textColor = UIColor.white
        
        // Values to labels of storyboard is assigned.
        cityNameLabel.text = cityName
        maximumTemperatureLabel.text = "Max. Temp. : " + maximumTemperature + " °C"
        minimumTemperatureLabel.text = "Min. Temp. : " + minimumTemperature + " °C"
        currentTemperatureLabel.text = "Current Temp. : " + currentTemperature + " °C"
        humidityLabel.text = "Humidity : " + "\(humidity ?? 00)" + " %"
        windSpeedLabel.text = "Wind Speed : " + windSpeed! + " m/s"
    }
    
    // Action Method : This will be called when user will tap on back button. It will dismiss the presented viewcontroller.
    @IBAction func BackButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
