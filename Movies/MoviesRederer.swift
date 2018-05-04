//
//  MoviesRederer.swift
//  Movies
//
//  Created by Sayed Abdo on 4/7/18.
//  Copyright © 2018 JETS. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData

class MoviesRederer: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    var mgr : DBmgr = DBmgr()
    var movies : [Movie] = [Movie]()
    var cached_movies : [NSManagedObject] = [NSManagedObject]()
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        print("hello")
        collectionView.delegate = self
        collectionView.dataSource = self
        if NetworkReachabilityManager()!.isReachable{
                    makeGetCallWithAlamofire()
            print("internet conncted")
            
        }else{
            print("no connection")
            
            let alert = UIAlertController(title: "no internet connection", message: "cached movies will be used instead", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            self.cached_movies = self.mgr.getData()
        }


    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if NetworkReachabilityManager()!.isReachable{
            print("internet conncted")
            return movies.count
        }else{
            return cached_movies.count}
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCellCollectionViewCell
        if NetworkReachabilityManager()!.isReachable{
            cell.image.sd_setImage(with: URL(string :movies[indexPath.row].poster_path!))

            
        }else{
            cell.image.sd_setImage(with: URL(string :cached_movies[indexPath.row].value(forKey: "image") as! String))

        }
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc : JETSMovieViewController = storyboard?.instantiateViewController(withIdentifier:"movie") as! JETSMovieViewController
        if NetworkReachabilityManager()!.isReachable{
            print("online selection")
            vc.movie = movies[indexPath.row]
            print(movies[indexPath.row])
           self.navigationController?.pushViewController(vc, animated: true)
        }else{
            print("offline selection")
            vc.cached_movie = cached_movies[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        

    }
    
    
    
  
    
     func makeGetCallWithAlamofire() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let todoEndpoint: String = "https://api.themoviedb.org/4/list/1?page=1&api_key=8788e175bc0da42177387d219a6a5779"
        self.mgr.deleteAllData()
        Alamofire.request(todoEndpoint)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    DispatchQueue.main.async {
                        let result : [JSON] = json["results"].arrayValue
                        
                    for h in result{
                           
                            var movie : Movie = Movie()
                            movie.overview = h["overview"].stringValue
                            movie.poster_path = "http://image.tmdb.org/t/p/w154/" + h["poster_path"].stringValue
                            movie.rating = h["vote_average"].floatValue
                            movie.title = h["title"].stringValue
                            movie.date = h["release_date"].stringValue
                            movie.id = h["id"].intValue
                        
                        self.mgr.saveData(name: movie.title,year:movie.date,rating:movie.rating,image:movie.poster_path,overview:movie.overview,id:movie.id,favourite:0)
                        
                        
                            self.movies.append(movie)
                        }
                        let counter : [NSManagedObject] = (self.mgr.getData())
                        print(counter.count)
                        self.collectionView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                case .failure(let error):
                    print(error)
                }
                
        }
        
    }
}
