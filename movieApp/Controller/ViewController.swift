//
//  ViewController.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/11/21.
//

import UIKit
import FSPagerView
import Kingfisher

class ViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }
    }
    
    //MARK: Variables
    var filteredTableData = [HomeModel]()
    var searchActive = false
    var searchController = UISearchController(searchResultsController: nil)

    var homeModel: [HomeModel] =  [HomeModel]()
//    func configureSearch() {
//        self.searchController = ({
//            let searchController = UISearchController(searchResultsController: nil)
//            searchController.searchResultsUpdater = self
//            searchController.obscuresBackgroundDuringPresentation = false
//            searchController.searchBar.placeholder = "Type name of movie"
//            searchController.searchBar.sizeToFit()
//            navigationItem.searchController = searchController
//            definesPresentationContext = true
//            return searchController
//        })()
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
//        configureSearch()
//        filteredTableData = homeModel
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell
        else{
            return UITableViewCell()
        }
        cell.delegate = self
        return cell
        
}
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let pagerView = FSPagerView()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "FSPagerViewCell")
        pagerView.transformer = FSPagerViewTransformer(type: .linear)
        self.view.addSubview(pagerView)
        return pagerView
        }
    func loadJson() {
            if let path = Bundle.main.path(forResource: "Movie", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                    let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                    let jsonData = try JSONSerialization.data(withJSONObject: jsonResult, options: .prettyPrinted)
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                     homeModel = try JSONDecoder().decode([HomeModel].self, from: jsonData)
                  } catch {

                  }
            }
        }
}

extension ViewController: HomeTableViewCellDelegate {
    func collectionView(collectionviewcell: HomeCollectionViewCell?, index: Int, didTappedInTableViewCell: HomeTableViewCell) {
        guard let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return  }
        vc.homeModel = homeModel[index]
        vc.movieDetailName = homeModel[index].originalTitle ?? ""
        vc.overviewDetail = homeModel[index].overview ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return homeModel.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "FSPagerViewCell", at: index)
        let defaultUrl = "https://image.tmdb.org/t/p/w500"
        let url = defaultUrl + (homeModel[index].posterPath ?? "")
        cell.imageView?.imageFromServerURL(url, placeHolder: nil)
        return cell
    }
}

//extension ViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        filteredTableData.removeAll(keepingCapacity: false)
//        let searchString = searchController.searchBar.text!.uppercased()
//
//        for item in homeModel {
//            if item.title?.uppercased().contains(searchString) == true {
////                searchActive = true
//                filteredTableData.append(item)
//            }
//        }
//        self.tableView.reloadData()
//    }
//}

