//
//  WeatherForecastCollectionCell.swift
//  Swift-Weather
//
//  Created by Ryan Sjoquist on 4/8/16.
//  Copyright © 2016 Northwoods. All rights reserved.
//

import UIKit

class WeatherForecastCollectionCell: UICollectionViewCell {
    
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var forecastTempLabel:UILabel!
    @IBOutlet var precipitationLabel:UILabel!
    @IBOutlet var weatherLabel:UILabel!
    @IBOutlet var weatherImageView:UIImageView!
    
    func setUpCell(temperature:String,time:String,precipitationPercentage:String?, weather:String, weatherImageString:String){
        
        timeLabel.text = time
        forecastTempLabel.text = temperature
        precipitationLabel.text = precipitationPercentage
        weatherLabel.text = weather
        loadImage(weatherImageString)
        
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        
    
        }
    
    func loadImage(imageName:String){
        if let url = NSURL(string: imageName){
            getDataFromURL(url) { (data, response, error) in
                if let data = NSData(contentsOfURL:url){
                    self.weatherImageView.image = UIImage(data: data)
                }
                else{
                    print(url)
                    print("fail at stage 1")
                    self.weatherImageView.image = nil
                }
            }
        }
    }
    
    func getDataFromURL(url:NSURL, completion:((data:NSData?, response:NSURLResponse?, error:NSError?)->Void)){
        let session = NSURLSession(configuration: .defaultSessionConfiguration(), delegate: WeatherDelegate(), delegateQueue:.mainQueue())
        session.dataTaskWithURL(url){(data,response,error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    


    }

