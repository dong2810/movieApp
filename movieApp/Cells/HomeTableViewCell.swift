//
//  HomeTableViewCell.swift
//  movieApp
//
//  Created by Nguyen Huy Dong on 7/12/21.
//

import UIKit

protocol HomeTableViewCellDelegate: class {
    func didSelectMovie(homeModel: HomeModel)
}

class HomeTableViewCell: UITableViewCell {
    
    //IBOutlet
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var headerLabel: UILabel!
    
    //variables
    private weak var delegate: HomeTableViewCellDelegate?
    var movie: HomeModel?
    
    var homeModel : [HomeModel] = []{
        didSet{
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadJson()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "HomeCollectionViewCell")
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
        return homeModel.count 
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.movieName.text = homeModel[indexPath.item].originalTitle
        let defaultUrl = "https://image.tmdb.org/t/p/w500"
        let url = defaultUrl + (homeModel[indexPath.item].posterPath)!
        cell.img.downloaded(from: url)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.height)
        }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectMovie(homeModel: homeModel[indexPath.row])
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
}

// chỗ này e chưa biết viết tiếp như nào
extension HomeTableViewCell: HomeTableViewCellDelegate {
    func didSelectMovie(homeModel: HomeModel) {
        self.movie = homeModel
    }
}

   


   
