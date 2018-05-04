//
//  JETSMovieViewController.swift
//  Movies
//
//  Created by Sayed Abdo on 4/12/18.
//  Copyright © 2018 JETS. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import CoreData
class JETSMovieViewController: UIViewController {
    var movie:Movie = Movie()
    var cached_movie : NSManagedObject = NSManagedObject()
    var mgr :DBmgr = DBmgr()
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBAction func adtofav() {
//        let vc : JETSFavouriteMoviesViewController = storyboard?.instantiateViewController(withIdentifier:"movie") as! JETSFavouriteMoviesViewController
        let image = UIImage(named: "star.png")
        let image2 = UIImage(named: "infilled-star.png")
        if NetworkReachabilityManager()!.isReachable{
            print(self.movie.title!)
            let status :Bool = self.mgr.addorRemoveFavourites(title: (self.movie.title)!)
            if status {
                self.button.setImage(image, for: .normal)
                movie.favourite = 1
            }else{
                self.button.setImage(image2, for: .normal)
                movie.favourite = 0
            }
        }else{
            print(self.cached_movie.value(forKey: "title") as! String )
            let status :Bool = self.mgr.addorRemoveFavourites(title: (self.cached_movie.value(forKey: "title"))! as! String )
            if status {
                self.button.setImage(image, for: .normal)
                cached_movie.setValue(1, forKey: "favourite")
            }else{
                self.button.setImage(image2, for: .normal)
                cached_movie.setValue(0, forKey: "favourite")
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let starimage = UIImage(named: "star.png")
        let starimage2 = UIImage(named: "infilled-star.png")
        if NetworkReachabilityManager()!.isReachable{
            self.rating.text =  String(format:"%f", (movie.rating!))
            self.image.sd_setImage(with: URL(string :(movie.poster_path!)))
            self.year.text = movie.title!
            self.overview.text = movie.overview!
            self.date.text = movie.date!
            let link : String = "https://m.youtube.com/results?search_query="
            
            let myStringArr = movie.title!.replacingOccurrences(of: " ", with: "+")
            let url : URL = URL(string: link+myStringArr+"+trailer")!
            let urlRequest : URLRequest = URLRequest(url: url)
            webView.load(urlRequest)
            if webView.isLoading{
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }else{
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if self.movie.favourite == 1{
                self.button.setImage(starimage, for: .normal)
            }
            if self.movie.favourite == 0{
                self.button.setImage(starimage2, for: .normal)
            }
        }else{
            
            
            let alert = UIAlertController(title: "no internet connection", message: "no offline videos", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            self.rating.text =  String(format:"%f", (cached_movie.value(forKey: "rating") as! Float))
            self.image.sd_setImage(with: URL(string :cached_movie.value(forKey: "image") as! String))
            self.year.text = cached_movie.value(forKey: "title") as? String
            self.overview.text = cached_movie.value(forKey: "overview") as? String
            self.date.text = cached_movie.value(forKey: "year") as? String
            if self.cached_movie.value(forKey: "favourite") as! Int == 1{
                self.button.setImage(starimage, for: .normal)
            }
            if self.cached_movie.value(forKey: "favourite") as! Int == 0{
                self.button.setImage(starimage2, for: .normal)
            }
            
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    


}
