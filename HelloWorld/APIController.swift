//
//  APIController.swift
//  HelloWorld
//
//  Created by Yusuke Kawanabe on 1/18/15.
//  Copyright (c) 2015 Yusuke Kawanabe. All rights reserved.
//

import Foundation

class APIController {
    
    var delegate: APIControllerProtocol
    
    init (delegate: APIControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as NSArray
            self.delegate.didReceiveAPIResults(jsonResult) // THIS IS THE NEW LINE!!
        })
        task.resume()
    }
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil);
        
        // Escape non url friendly terms
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=music&entity=album"
            get(urlPath)
        }
    }
}

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}