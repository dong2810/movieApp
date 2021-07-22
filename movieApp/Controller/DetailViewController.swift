//
//  DetailViewController.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/19/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var imgDetail: UIImageView!
    var imgDetailMovie: UIImage!
    var homeModel = [HomeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgDetail.image = imgDetailMovie
        // Do any additional setup after loading the view.
    }
}

