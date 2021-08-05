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
    var movieDetailName = ""
    var overviewDetail = ""
    var imgDetailMovie: UIImage!
    var homeModel : HomeModel!
    override func viewDidLoad() {					
        super.viewDidLoad()
        imgDetail.image = imgDetailMovie
        movieName.text = movieDetailName
        overview.text = overviewDetail
        let defaultUrl = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: defaultUrl + (homeModel.posterPath ?? ""))
        imgDetail.kf.setImage(with: url)
        // Do any additional setup after loading the view.
    }
}


