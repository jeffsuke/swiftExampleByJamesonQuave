//
//  ViewController.swift
//  HelloWorld
//
//  Created by Yusuke Kawanabe on 1/7/15.
//  Copyright (c) 2015 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var appsTableView: UITableView!
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("Hello World")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: .Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel?.text = "Row #\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func searchItunesFor(searchTerm: String) {
        let itunesSearchTearm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        if let escapedSearchTerm = itunesSearchTearm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
                println("Task completed")
                if (error != nil) {
                    println(error.localizedDescription)
                }
                var err: NSError?
                
                var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                println("JSON Error \(err?.localizedDescription)")
                
                let results = jsonResult["results"] as NSArray
                dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.appsTableView!.reloadData()
                })
            })

        }
    
    }
}

