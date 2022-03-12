//
//  HomeCollectionViewController.swift
//  2coderMovies
//
//  Created by Vasil Panov on 10.3.22.
//

import UIKit


class HomeCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [Movie]?
    var pageCounter = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Movies"
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchMovies()
    }
    
    private func fetchMovies() {
        ApiManager.shared.fetchMoviesList(pagination: true, page: pageCounter, completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print(error)
                
            case .success(let movies):
                self.movies = movies.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
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
// MARK: UICollectionViewDataSource

extension HomeCollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        return cell
    }
}

extension HomeCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180.0, height: 300.0)
    }
}

extension HomeCollectionViewController : UIScrollViewDelegate {
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
