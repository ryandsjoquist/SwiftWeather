//
//  WeatherForecastCollectionViewController.swift
//  Swift-Weather
//
//  Created by Ryan Sjoquist on 4/10/16.
//  Copyright © 2016 Northwoods. All rights reserved.
//

import UIKit

class WeatherForecastCollectionViewController: UICollectionViewController{
    
    
    
    struct Forecast
    {
        var startPeriodName:String
        var temperature:String
        var pop:String?
        var weather:String
        var weatherImageString:String
        
        init(temperature:String, startPeriodName:String, pop:String?, weather:String, weatherImageString:String)
        {
            self.startPeriodName = startPeriodName
            self.temperature = temperature
            self.pop = pop
            self.weather = weather
            self.weatherImageString = weatherImageString
        }
    }
    
    let jsonURL = NSURL(string:"http://forecast.weather.gov/MapClick.php?lat=40.1024362&lon=-83.1483597&FcstType=json")!
    var forecastData:Array< Forecast > = Array < Forecast >()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        httpGet(NSMutableURLRequest(URL: jsonURL))
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        do_refresh()

    }
    
    override func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath)->UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! WeatherForecastCollectionCell
    
        for forcast in forecastData{
            cell.setUpCell(forcast.temperature, time:forcast.startPeriodName, precipitationPercentage: forcast.pop, weather: forcast.weather, weatherImageString: forcast.weatherImageString)
        }
        
        return cell
    }
    
    func parseJSON(json:[String:AnyObject]){
        guard let timeData = json["time"] as? [String: AnyObject] else {
            return
        }
        guard let weatherData = json["data"] as? [String:AnyObject] else {
            return
        }
        guard let forecastedTime = timeData["startPeriodName"]as? [String] else {
            return
        }
        guard let forecastedTemps = weatherData["temperature"] as? [String] else {
            return
        }
        guard let forecastedPercentages = weatherData["pop"] as? NSArray else {
            return
        }
        guard let forecastedWeather = weatherData["weather"] as? [String] else {
            return
        }
        guard let forecastedWeatherImage = weatherData["iconLink"] as? [String] else {
            return
        }
        forecastData = []
        for index in 0..<forecastedWeather.count{
           let forecast = Forecast(temperature:forecastedTemps[index],
                                                startPeriodName: forecastedTime[index],
                                                pop: forecastedPercentages[index] as? String,
                                                weather: forecastedWeather[index],
                                                weatherImageString: forecastedWeatherImage[index]
            )
            forecastData.append(forecast)
        }
        
        print(forecastData)
    
    }
    
    func httpGet(request: NSMutableURLRequest!) {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: configuration,
                                   delegate:WeatherDelegate(),
                                   delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error == nil {
//                set and load data, and reloadData
                
                let json = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                self.parseJSON(json as! [String:AnyObject])
                self.do_refresh()
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
    
    func do_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView?.reloadData()
        })
    }
    
   override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return forecastData.count

    }
    

    
    
    
}
