//
//  WeatherDelegate.swift
//  Swift-Weather
//
//  Created by Ryan Sjoquist on 4/8/16.
//  Copyright © 2016 Northwoods. All rights reserved.
//

import Foundation

class WeatherDelegate: NSObject, NSURLSessionDelegate {
    
    func URLSession(session: NSURLSession, challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void){
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && Constants.selfSignedHosts.contains(challenge.protectionSpace.host){
            let credential = NSURLCredential(forTrust:challenge.protectionSpace.serverTrust!)
            completionHandler(.UseCredential, credential)
        } else {
            completionHandler(.PerformDefaultHandling, nil)
        }
        
    }

    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didReceiveChallenge challenge: NSURLAuthenticationChallenge!, completionHandler: ((NSURLSessionAuthChallengeDisposition, NSURLCredential!) -> Void)!){
        print("task recived challange")
        if challenge.previousFailureCount > 0 {
            print("Please Check Credential")
            completionHandler(NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
        } else {
            let credential = NSURLCredential(user:"username", password:"password", persistence: .ForSession)
            completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
        }
        
        
    }
    
    struct Constants {
        static let selfSignedHosts: Set<String> =
            ["http://forecast.weather.gov"]
    }
}