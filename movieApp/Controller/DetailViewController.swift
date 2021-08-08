//
//  DetailViewController.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/19/21.
//

import UIKit
import Kingfisher
import HCSStarRatingView
class DetailViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var viewMovie: UIView!
    @IBOutlet private weak var imgDetail: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var ratingBar: HCSStarRatingView!
    
    // MARK: Varibales
    var homeModel : HomeModel?
    
    var currentIndex:Int = 0
    
    override func viewDidLoad() {					
        super.viewDidLoad()
        movieName.text = homeModel?.title
        overview.text = homeModel?.overview
        let defaultUrl = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: defaultUrl + (homeModel?.posterPath ?? ""))
        imgDetail.kf.setImage(with: url)
        // Do any additional setup after loading the view.
    }
}


