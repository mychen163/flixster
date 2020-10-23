//
//  WebViewController.swift
//  flixster
//
//  Created by M.y Chen on 10/22/20.
//

import UIKit
import WebKit

class WebViewController: UIViewController{
    var movie: [String:Any]!
    var youtubeKey = ""
  

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var back: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movie_id = movie["id"] as! Int
        let url = URL(string:"https://api.themoviedb.org/3/movie/"+String(movie_id)+"/videos?api_key=bbddcf1a33f7af63249abee7f0d4e41c&language=en-US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                print(dataDictionary)
                // get the results
                let results = dataDictionary["results"] as! [[String:Any]]
                // get the youtubeKey
                self.youtubeKey = results[0]["key"] as! String
                
                // baseUrl ofr youtube
                let baseUrl = "https://www.youtube.com/watch?v="
                let movieTrailerUrl = String(baseUrl + self.youtubeKey)
                self.webView.load(URLRequest(url: URL(string: movieTrailerUrl)!))
            }
        }
        task.resume()
        // Do any additional setup after loading the view.
    }
    

    
    @IBAction func backToDetailView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
