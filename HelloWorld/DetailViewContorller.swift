//
//  DetailViewContorller.swift
//  HelloWorld
//
//  Created by Yusuke Kawanabe on 1/26/15.
//  Copyright (c) 2015 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, APIControllerProtocol {
    lazy var api: APIController = APIController(delegate: self)
    var album:Album?
    var tracks = [Track]()
    
    @IBOutlet weak var tracksTableView: UITableView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        if album != nil {
            api.lookUpAlbum(album!.collectionId)
        }
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSArray = results["results"] as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tracks = Track.trackWithJSON(resultsArr)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}