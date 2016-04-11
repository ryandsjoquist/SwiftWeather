//
//  ViewController.swift
//  Swift-Weather
//
//  Created by Steve Madsen on 2/16/16.
//  Copyright © 2016 Northwoods. All rights reserved.
//

import UIKit


class ViewController: UIViewController,NSURLSessionDelegate {
    
    let jsonURL = NSURL(string:"http://forecast.weather.gov/MapClick.php?lat=40.1024362&lon=-83.1483597&FcstType=json")!
    let baseImageURL = NSURL(string:"http://forecast.weather.gov/newimages/medium/")!
    
    @IBOutlet var visibilityLabel:UILabel!
    @IBOutlet var windsLabel:UILabel!
    @IBOutlet var currentDateLabel:UILabel!
    @IBOutlet var locationLabel:UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            dispatch_async(dispatch_get_main_queue()) {
                self.httpGet(NSMutableURLRequest(URL: self.jsonURL))
            }
        }
        imageView.contentMode = .ScaleAspectFit
    }
    
    func httpGet(request: NSMutableURLRequest!) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration,
                                   delegate:WeatherDelegate(),
                                   delegateQueue:NSOperationQueue.mainQueue())
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error == nil {
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                self.updateCurrentWeatherConditions(json as! [String:AnyObject])
            }
        }
        task.resume()
    }
    
    func getDataFromURL(url:NSURL, completion:((data:NSData?, response:NSURLResponse?, error:NSError?)->Void)){
        let session = NSURLSession(configuration: .defaultSessionConfiguration(), delegate: WeatherDelegate(), delegateQueue:.mainQueue())
        session.dataTaskWithURL(url){(data,response,error) in
            completion(data: data, response: response, error: error)
        }.resume()
    }

    func loadImage(imageName:String){
        let url = baseImageURL.URLByAppendingPathComponent(imageName)
        getDataFromURL(url) { (data, response, error) in
            if let data = NSData(contentsOfURL:url){
            self.imageView.image = UIImage(data: data)
            }
            else{
                print(url)
                print("fail at stage 1")
                self.imageView.image = nil
            }
        }
    }
    
    func updateCurrentWeatherConditions(json:[String:AnyObject]){
        
        guard let currentObservation = json["currentobservation"] as? [String: String] else { return }
        
        if let imageName = currentObservation["Weatherimage"]{
            print(imageName)
        loadImage(imageName)
        }else{
            print("fail at stage 2")
            self.imageView.image = nil
        }
        
        visibilityLabel.text = "\(currentObservation["Visibility"]!) Miles"
        windsLabel.text = "\(currentObservation["Winds"]!) MPH"
        locationLabel.text = currentObservation["name"]
        currentDateLabel.text = currentObservation["Date"]
        temperatureLabel.text = "\(currentObservation["Temp"]!)º"
        feelsLikeLabel.text = "Feels Like \(currentObservation["WindChill"]!)º"
        weatherLabel.text = currentObservation["Weather"]
    }
    
    
    
}





