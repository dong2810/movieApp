//
//  DetailViewController.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/19/21.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet private weak var imgDetail: UIImageView!
    var imgDetailMovie = UIImage()
    var homeModel1: [HomeModel]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgDetail.image = imgDetailMovie
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

