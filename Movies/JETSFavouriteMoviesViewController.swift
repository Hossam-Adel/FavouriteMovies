//
//  JETSFavouriteMoviesViewController.swift
//  Movies
//
//  Created by Sayed Abdo on 4/13/18.
//  Copyright © 2018 JETS. All rights reserved.
//

import UIKit
import CoreData
private let reuseIdentifier = "Cell"

class JETSFavouriteMoviesViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource {
    @IBOutlet var collectionView: UICollectionView!
    var mgr : DBmgr = DBmgr()
    var movies : [NSManagedObject] = [NSManagedObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = (mgr.selectFavourites())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        movies = (mgr.selectFavourites())
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! CustomCellCollectionViewCell
        print(movies[indexPath.row].value(forKey: "image")!, String("hhhhhh"))
        if movies.count > 0{
            cell.image.sd_setImage(with: URL(string : movies[indexPath.row].value(forKey: "image") as! String))
          
            
        }else{
            let alert = UIAlertController(title: "Empty", message: "no favourite movies", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        }
        return cell
    }
    

   

    

}
