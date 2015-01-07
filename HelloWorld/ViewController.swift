//
//  ViewController.swift
//  HelloWorld
//
//  Created by Yusuke Kawanabe on 1/7/15.
//  Copyright (c) 2015 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var appsTableView: UITableView?
     
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

}

