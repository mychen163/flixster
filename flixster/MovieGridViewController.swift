//
//  MovieGridViewController.swift
//  flixster
//
//  Created by M.y Chen on 10/21/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies = [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 4
       
        let width = (view.frame.size.width - 2 * layout.minimumInteritemSpacing) / 3
        print(view.frame.size.width) //414.0
        print(width) //135.33333333333334
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=bbddcf1a33f7af63249abee7f0d4e41c&language=en-US&page=1")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.movies = dataDictionary["results"] as! [[String:Any]]
                self.collectionView.reloadData()
            }
        }
        task.resume()
    }
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    
}
