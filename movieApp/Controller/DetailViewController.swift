//
//  DetailViewController.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/19/21.
//

import UIKit
import Kingfisher
class DetailViewController: UIViewController {

    @IBOutlet weak var viewMovie: UIView!
    @IBOutlet private weak var imgDetail: UIImageView!
    var imgDetailMovie: UIImage!
    var homeModel : HomeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgDetail.image = imgDetailMovie
        let defaultUrl = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: defaultUrl + (homeModel.posterPath ?? ""))
        imgDetail.kf.setImage(with: url)
        // Do any additional setup after loading the view.
    }
}


