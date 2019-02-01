//
//  HTTPNetworking.swift
//  earthQuakeCheck
//
//  Created by Nick on 1/20/19.
//  Copyright © 2019 NickOwn. All rights reserved.
//



import Foundation
import UIKit
import CoreLocation

protocol Networking {
    
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func getEarthQuakeObjs(location: CLLocation, completion:@escaping(_ objs:[earthQuakeObj]) -> ())
}

struct HTTPNetworking: Networking {
    
    
    func getEarthQuakeObjs(location: CLLocation, completion:@escaping(_ objs:[earthQuakeObj]) -> ()) {
        
        let queryDateformatter = DateFormatter()
        queryDateformatter.dateFormat = "yyyy-MM-dd"
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let endDateStr = queryDateformatter.string(from: Date())
        let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())
        let startDateStr = queryDateformatter.string(from: startDate!)
        
        
        let urlstr = "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson&starttime=\(startDateStr)&endtime=\(endDateStr)&latitude=\(latitude)&longitude=\(longitude)&maxradiuskm=\(setting.shared.distance!)"
        
        let url = URL(string: urlstr)!
        
        self.request(url: url, completion: { data in
            if let responseData = data {
                do {
                    var returnObjs = [earthQuakeObj]()
                    guard let jsondata = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [String: Any] else {
                            print("error trying to convert data to JSON")
                            return
                    }
        
            
                    if let featuresDicts = jsondata["features"] as? [[String:Any]] {
                        for dict in featuresDicts {
                            if let tmpObj = earthQuakeObj.init(featuresDict: dict) {
                                returnObjs.append(tmpObj)
                            }
                            
                        }
                        completion(returnObjs)
                    }
                    
                    
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
        })
        
        
    }
    
    
    func request(url: URL, completion:@escaping (_ data:Data?) -> ()) {
        let task = createDataTask(url: url, completion: { data,response, error in
            //if error, call handleError method
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                self.handleError(response)
                return
            }
            
            completion(data)
            
            
        })
        task.resume()
    }
    
    //handle server side error with alert view controller
    func handleError(_ response: URLResponse?) {
        let alertVC = UIAlertController(title: "Error", message: "Something wrong", preferredStyle: .alert)
        let action_OK = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
        alertVC.addAction(action_OK)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            topController.present(alertVC, animated: true, completion: nil)
        }
        
        
    }
    
    private func createDataTask(url:URL, completion:@escaping CompletionHandler) -> URLSessionTask{
        return URLSession.shared.dataTask(with: url){ data, response, error in
            completion(data, response, error)
        }
    }
    
}

//RETURN VALUSE - features
//{
//    "type": "Feature",
//    "properties": {
//        "mag": 1.78,
//        "place": "6km ESE of Jackson, Missouri",
//        "time": 1546316266040,
//        "url": "https://earthquake.usgs.gov/earthquakes/eventpage/nm60071823",
//        "detail": "https://earthquake.usgs.gov/fdsnws/event/1/query?eventid=nm60071823&format=geojson",
//        "magType": "md",
//        "type": "earthquake",
//        "title": "M 1.8 - 6km ESE of Jackson, Missouri"
//    },
//    "geometry": {
//        "type": "Point",
//        "coordinates": [
//        -89.5941667,
//        37.3566667,
//        11.08
//        ]
//    },
//    "id": "nm60071823"
//}

extension earthQuakeObj {
    init?(featuresDict:[String:Any]) {
        guard let properties = featuresDict["properties"] as? [String:Any], let title = properties["title"] as? String,let place = properties["place"] as? String, let timeNumber = properties["time"] as? Double, let url = properties["url"] as? String else {
            return nil
        }
        
        guard let geometry = featuresDict["geometry"] as? [String:Any], let coordinates = geometry["coordinates"] as? [Any], let latitude = coordinates[0] as? Double, let longitude = coordinates[1] as? Double else {
            return nil
        }
        
        self.place = place
        self.location = (latitude, longitude)
        self.url = URL(string: url)!
        
        let convertDate = Date(timeIntervalSince1970: timeNumber / 1000)
        self.time = convertDate
        self.title = title
        
    }
}
