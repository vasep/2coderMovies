//
//  HomeCollectionViewController.swift
//  2coderMovies
//
//  Created by Vasil Panov on 10.3.22.
//

import UIKit


class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favoriteMoviesArray = [FavoriteMovies]()
    var movies: [Movie]?
    var pageCounter = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movies"
        fetchFavoriteMoviesFromDB()
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchMovies()
    }
    
    private func fetchFavoriteMoviesFromDB() {
        do {
            self.favoriteMoviesArray = try context.fetch(FavoriteMovies.fetchRequest())
        } catch {
            //error
        }
    }
    
    private func fetchMovies() {
        ApiManager.shared.fetchMoviesList(pagination: true, page: pageCounter, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let movies):
                self.movies = movies.results
                self.checkForFavorites()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    private func checkForFavorites() {
        for movie in 0..<movies!.count {
            for favorite in 0..<favoriteMoviesArray.count {
                if movies![movie].original_title!.contains(favoriteMoviesArray[favorite].movieTitle!) {
                    self.movies![movie].favorite = true
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UICollectionViewCell
        let indexPath = self.collectionView!.indexPath(for: cell)
        guard let selectedMovie = movies?[indexPath!.row] else {
            return
        }
        if let target = segue.destination as? MovieDetailsViewController {
            target.movie = selectedMovie
        }
    }
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegate

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        // Configure the cell
        cell.setup(movies: movies![indexPath.row])
        cell.delegate = self
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
// Sets the width and height of the Cell

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width - 12 * 3) / 2 //some width
        let height = width * 2 //ratio
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController : MovieCollectionViewCellDelegate {
    func favBtnClicked(movie: Movie) {
        addFavoriteMovie(movie: movie)
    }
    
    private func addFavoriteMovie(movie : Movie) {
        let myalert = UIAlertController(title: "Add Favorite Movie", message: "Are you sure you that you want to add this movie to your favorite list?", preferredStyle: UIAlertController.Style.alert)
        
        myalert.addAction(UIAlertAction(title: "Accept", style: .default) { (action:UIAlertAction!) in
            let item = FavoriteMovies(context: self.context)
            item.movieTitle = movie.title
            item.movieDescription = movie.overview
            item.moviesImage = movie.poster_path
            do{
                try self.context.save()
            } catch {
                //error
            }
        })
        myalert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel")
        })
        
        self.present(myalert, animated: true)
    }
}

extension HomeViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > collectionView.contentSize.height-100-scrollView.frame.size.height {
            //fetch more data
            
            guard !ApiManager.shared.isPaginating else {
                //we are already fetching more data
                return
            }
            self.pageCounter += 1
            
            ApiManager.shared.fetchMoviesList(pagination: true, page: self.pageCounter, completion: { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .failure(let error):
                    print(error)
                    
                case .success(let movies):
                    self.movies?.append(contentsOf: movies.results!)
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            })
        }
    }
}
