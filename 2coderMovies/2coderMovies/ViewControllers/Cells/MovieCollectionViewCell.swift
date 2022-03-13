//
//  MoveCollectionViewCell.swift
//  2coderMovies
//
//  Created by Vasil Panov on 10.3.22.
//

import UIKit
import SDWebImage

protocol MovieCollectionViewCellDelegate : NSObjectProtocol{
    func favBtnClicked(movie : Movie)
}

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var favoriteBtn: UIButton!
    var movie : Movie?
    var favoriteMovies : FavoriteMovies?
    weak var delegate : MovieCollectionViewCellDelegate!
    
    func setupFavMovies(movies : FavoriteMovies) {
        self.favoriteMovies = movies
        titleLbl.text = movies.movieTitle
        DispatchQueue.main.async() { [weak self] in
            self!.movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(movies.moviesImage ?? "")"), placeholderImage: UIImage(systemName: "photo.circle"))
        }
    }
    
    func setup(movies : Movie) {
        self.movie = movies
        titleLbl.text = movies.original_title
        descriptionLbl.text = movies.overview
        DispatchQueue.main.async() { [weak self] in
            self!.movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(movies.poster_path ?? "")"), placeholderImage: UIImage(systemName: "photo.circle"))
            if movies.favorite {
                self!.favoriteBtn.tintColor = UIColor.yellow
            } else {
                self!.favoriteBtn.tintColor = UIColor.white
            }
        }
    }
    
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        guard let favMovie = movie else {
            return
        }
        self.delegate.favBtnClicked(movie: favMovie)
        favoriteBtn.tintColor = UIColor.yellow
    }
}
