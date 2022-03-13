//
//  FavoriteMovies+CoreDataProperties.swift
//  2coderMovies
//
//  Created by Vasil Panov on 13.3.22.
//
//

import Foundation
import CoreData


extension FavoriteMovies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovies> {
        return NSFetchRequest<FavoriteMovies>(entityName: "FavoriteMovies")
    }

    @NSManaged public var movieTitle: String?
    @NSManaged public var moviesImage: String?
    @NSManaged public var movieDescription: String?

}

extension FavoriteMovies : Identifiable {

}
