//
//  ViewController.swift
//  SmartApp
//
//  Created by coder on 12/31/14.
//  Copyright (c) 2014 appliaison. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {

    private let apiKey = "da703e80f1937b3164584bdfb24b6030"
    
    let locationManager = CLLocationManager()
    
    // http://cloford.com/resources/colours/500col.htm
    // palegreen3 for view background
    // darkolivegreen4 for TextContainer view
    // https://api.forecast.io/forecast/da703e80f1937b3164584bdfb24b6030/37.8267,-122.423
    

    @IBOutlet weak var weatherIconView: UIImageView!
    
    @IBOutlet weak var currentLocationLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var centerIconView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var precipitationLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 36.7783, longitude: 119.4179)
    
    
    
    @IBOutlet weak var refreshButton: UIButton!
	@IBAction func refreshButtonTapped(_ sender: Any) {
		print("refreshButtonTapped")
		getCurrentWeatherData()
		self.refreshButton.isHidden = true
		
		self.refreshActivityIndicator.isHidden = false
		
		self.refreshActivityIndicator.startAnimating()
	}


    
    func getCurrentWeatherData() -> Void {
        let baseUrl = NSURL(string:"https://api.darkskey.net/forecast/\(apiKey)/")
        // let forecastUrl = NSURL(string: "37.8267,-122.423", relativeToURL:baseUrl)
        let coordinateString = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
		let forecastUrl = URL(string:coordinateString, relativeTo:baseUrl as! URL)
        
		let weatherData = try? NSData(contentsOf: forecastUrl! as URL, options: [])
        
		let sharedSession = URLSession.shared
        
		let downloadTask: URLSessionDownloadTask = sharedSession.downloadTask(with: forecastUrl!,
            completionHandler: { (location: URL?, response: URLResponse?, error: NSError?) -> Void in
                if (error == nil) {
					let dataObject = NSData(contentsOf: location!)
                    
					let weatherDictionary: NSDictionary = (try! JSONSerialization.jsonObject(with: dataObject! as Data, options: [])) as! NSDictionary
                    
                    var currentWeatherDictionary: NSDictionary = weatherDictionary["currently"] as! NSDictionary
                    
                    
                    let currentWeather = Current(weatherDictionary: weatherDictionary)
					
					
					DispatchQueue.main.async(execute: { () -> Void in
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is \(currentWeather.summary)"
                        self.centerIconView.image = currentWeather.icon!
                        self.temperatureLabel.text = "\(currentWeather.temperature)"
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                        
                        self.refreshActivityIndicator.stopAnimating()
						self.refreshActivityIndicator.isHidden = true
						self.refreshButton.isHidden = false
                    })
                } else {
					let networkIssueController = UIAlertController(title: "Error", message: "Connectivity Error", preferredStyle: .alert)
					let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                    networkIssueController.addAction(okButton)
					let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    networkIssueController.addAction(cancelButton)
					self.present(networkIssueController, animated: true, completion: nil)
                    
					DispatchQueue.main.async(execute: { () -> Void in
                        
						self.refreshButton.isHidden = false
                    
						self.refreshActivityIndicator.isHidden = true
                        
                        self.refreshActivityIndicator.stopAnimating()
                        
                    })
                }
                
				} as! (URL?, URLResponse?, Error?) -> Void)
        
        downloadTask.resume()

    }
    
    
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		self.refreshActivityIndicator.isHidden = true
        // self.coordinate.latitude = 37.8267
        // self.coordinate.longitude = -122.423
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest

            print("Start updating location")
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled")
        }
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CoreLocation Delegate Methods
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
        // removeLoadingView()
        /*
        if ((error)) {
            print(error, terminator: "")
        }
        */
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        self.coordinate = locationObj.coordinate
        print("Latitude\(self.coordinate.latitude)")
        print("Longitude\(self.coordinate.longitude)")
        getCurrentWeatherData()
    }
    


}

