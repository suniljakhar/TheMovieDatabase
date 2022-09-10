import Foundation

struct MovieViewModel {
    
    let movie: PopularResult.Popular.Movie
    
    init(movie: PopularResult.Popular.Movie) {
        self.movie = movie
    }
    
    var title: String {
        return self.movie.title
    }
    
    var rating: String {
        return "4.5"
    }
    
    var playlist: String {
        return ""
    }
    
    var imdbID: String {
        return self.movie.imdbID
    }
    
    var imageURL: String {
        return self.movie.poster
    }
}
