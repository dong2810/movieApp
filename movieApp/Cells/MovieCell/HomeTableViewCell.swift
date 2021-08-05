//
//  HomeTableViewCell.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/12/21.
//

import UIKit

protocol HomeTableViewCellDelegate: class {
    func collectionView(collectionviewcell: HomeCollectionViewCell?, index: Int, didTappedInTableViewCell: HomeTableViewCell)
}

class HomeTableViewCell: UITableViewCell, UISearchBarDelegate {
    
    //IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerLabel: UILabel!
    
    //variables
    weak var delegate: HomeTableViewCellDelegate?
    
    var movie: HomeModel?
    var searchController = UISearchController(searchResultsController: nil)
    var filteredTableData = [HomeModel]()
    var searchActive = false
    
    var homeModel : [HomeModel] = []{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
            collectionView.register(UINib(nibName: "UpCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "UpCollectionViewCell")
            collectionView.reloadData()
        }
    }
    
    func configureSearch() {
        self.searchController = ({
            searchController.loadViewIfNeeded()
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.enablesReturnKeyAutomatically = false
            searchController.searchBar.returnKeyType = UIReturnKeyType.done
            searchController.searchBar.placeholder = "Type name of movie"
            searchController.searchBar.sizeToFit()
            
            return searchController
        })()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadJson()
        configureSearch()
        let url = URL(string: "https://image.tmdb.org/t/p/w500")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                do {
                    self.homeModel = try JSONDecoder().decode([HomeModel].self, from: data!)
                }catch {
                    print("Parse Error")
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }.resume()
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
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func seeAllButton(_ sender: Any) {
        //        onClickSeeAll?(index)
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchActive {
            return filteredTableData.count
        }
        else {
            return homeModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        if searchActive {
            cell.movieName.text = filteredTableData[indexPath.item].originalTitle
            let defaultUrl = "https://image.tmdb.org/t/p/w500"
            let url = defaultUrl + (filteredTableData[indexPath.item].posterPath)!
            cell.img.downloaded(from: url)
        }
        else {
            cell.movieName.text = homeModel[indexPath.item].originalTitle
            let defaultUrl = "https://image.tmdb.org/t/p/w500"
            let url = defaultUrl + (homeModel[indexPath.item].posterPath)!
            cell.img.downloaded(from: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.delegate?.collectionView(collectionviewcell: cell as? HomeCollectionViewCell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.kf.setImage(with: URL(string: URLString))
    }
}

extension HomeTableViewCell: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //        filteredTableData.removeAll(keepingCapacity: false)
        let searchString = searchController.searchBar.text!
        if !searchString.isEmpty {
            searchActive = true
            filteredTableData.removeAll()
            for item in homeModel {
                if item.title?.uppercased().contains(searchString.uppercased()) == true{
                    filteredTableData.append(item)
                }
            }
        }
        else {
            searchActive = false
            filteredTableData.removeAll()
            filteredTableData = homeModel
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        filteredTableData.removeAll()
        collectionView.reloadData()
    }
}



