//
//  Requestable.swift
//  CCCtv
//
//  Created by Kris Simon on 13/12/15.
//  Copyright © 2015 aus der Technik. All rights reserved.
//

import Foundation
import SwiftyJSON

let apiUrl = "https://api.media.ccc.de/public"

enum RequestError {
    case JsonError
    case RequestError
    case MissingContextError
}

protocol Requestable : class {
    var jsonData: JSON { get set }
    var requestUrl: String { get }
    
    //init()
}


extension Requestable {
    
    func performRequest(completionHandler: @escaping (RequestError?, JSON?)->()) {
        let url = NSURL(string: "\(apiUrl)\(requestUrl)")
        
        let configuration = URLSessionConfiguration.default
        
        let request = URLRequest(url: url! as URL)
        
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            if error != nil {
                NSLog(error!.localizedDescription)
                completionHandler( RequestError.RequestError, nil)
            } else {
                let json = try! JSON(data: data!)
                if json.error != nil {
                    NSLog(json.error!.localizedDescription)
                    completionHandler(RequestError.JsonError, nil)
                } else {
                    self.jsonData = json
                    completionHandler(nil, json)
                }
            }
        }
        task.resume()
    }
    
}
