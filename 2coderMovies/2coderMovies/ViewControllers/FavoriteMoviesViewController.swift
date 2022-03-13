//
//  FavoriteMoviesViewController.swift
//  2coderMovies
//
//  Created by Vasil Panov on 13.3.22.
//

import UIKit

class FavoriteMoviesViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var favoriteMoviesArray : [FavoriteMovies]?
    @IBOutlet weak var noFavMoviesLbl : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favorite Movies"
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchItemsFromDB()
    }
    
    func fetchItemsFromDB() {
        do {
            self.favoriteMoviesArray = try context.fetch(FavoriteMovies.fetchRequest())
            if favoriteMoviesArray?.count == 0 {
                noFavMoviesLbl.isHidden = false
                collectionView.isHidden = true
            } else {
                noFavMoviesLbl.isHidden = true
                collectionView.isHidden = false
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }

        } catch {
            //error
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPath(for: cell)

        if let target = segue.destination as? MovieDetailsViewController {
            target.isFavorite = true
            target.favoriteMovie = favoriteMoviesArray![indexPath!.row]
        }
    }
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate

extension FavoriteMoviesViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteMoviesArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        // Configure the cell
        cell.setupFavMovies(movies: favoriteMoviesArray![indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
// Sets the width and height of the Cell

extension FavoriteMoviesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 12 * 3) / 2 //some width
        let height = width * 2 //ratio
        return CGSize(width: width, height: height)
    }
}
