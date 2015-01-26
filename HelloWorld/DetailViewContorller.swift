//
//  DetailViewContorller.swift
//  HelloWorld
//
//  Created by Yusuke Kawanabe on 1/26/15.
//  Copyright (c) 2015 Yusuke Kawanabe. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var album:Album?
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLable.text = album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
    }
}