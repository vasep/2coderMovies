//
//  ViewController.swift
//  2coderMovies
//
//  Created by Vasil Panov on 10.3.22.
//

import UIKit
import SDWebImage

class MovieDetailsViewController: UIViewController {
    var movie : Movie?
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieIMage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = movie?.title
        self.movieDescription.text = movie?.overview
        DispatchQueue.main.async() { [weak self] in
            self!.movieIMage.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w185/\(self!.movie?.poster_path ?? "")"), placeholderImage: UIImage(systemName: "photo.circle"))
        }
    }
}
