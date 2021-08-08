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
            tableView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.reloadData()
        }
    }
    
    //MARK: Variables
    var detail: HomeModel?
    var filteredTableData: [HomeModel] = [HomeModel]()
    var searchActive = false
    var searchController = UISearchController(searchResultsController: nil)
    
    var homeModel: [HomeModel] =  [HomeModel]()
    var homeModels = [String].self {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadJson()
        configureSearch()
    }
    
    func configureSearch() {
        self.searchController = ({
            let searchController = UISearchController(searchResultsController: nil)
            searchController.searchResultsUpdater = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Type name of movie"
            searchController.searchBar.sizeToFit()
            tableView.tableHeaderView = searchController.searchBar
            definesPresentationContext = true
            navigationItem.hidesSearchBarWhenScrolling = false
            return searchController
        })()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filteredTableData.count
        }
        else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchActive {
            return 150
        }
        return 235
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchActive {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell
            else{
                return UITableViewCell()
            }
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + (filteredTableData[indexPath.row].backdropPath ?? ""))
            cell.imgMovie.kf.setImage(with: url)
            cell.movieName.text = filteredTableData[indexPath.row].title
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as? HomeTableViewCell
            else{
                return UITableViewCell()
            }
            cell.delegate = self
            return cell
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController{
            destination.homeModel = filteredTableData[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

extension ViewController: HomeTableViewCellDelegate {
    func collectionView(collectionviewcell: HomeCollectionViewCell?, index: Int, didTappedInTableViewCell: HomeTableViewCell) {
        guard let vc = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return  }
        vc.homeModel = homeModel[index]
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

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text!
        if !searchString.isEmpty {
            searchActive = true
            filteredTableData.removeAll()
            for item in homeModel {
                if item.title?.uppercased().contains(searchString.uppercased()) == true{
                    filteredTableData = homeModel.filter({ $0.title!.contains(searchString) })
                }
            }
        }
        else {
            searchActive = false
            filteredTableData.removeAll()
            filteredTableData = homeModel
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        filteredTableData.removeAll()
        tableView.reloadData()
    }
}
