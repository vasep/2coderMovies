//
//  MoveCollectionViewCell.swift
//  2coderMovies
//
//  Created by Vasil Panov on 10.3.22.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    func setup(movies : Movie) {
        titleLbl.text = movies.original_title
        DispatchQueue.main.async() { [weak self] in
            self!.movieImage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(movies.poster_path ?? "")"), placeholderImage: UIImage(systemName: "photo.circle"))
        }
    }
}
