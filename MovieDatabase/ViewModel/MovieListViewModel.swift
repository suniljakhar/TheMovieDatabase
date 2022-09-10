import Foundation

class MovieViewModelList {
    var viewModelUpdates: (() -> Void) = {  }
    var errorOccurred: ((NetworkError) -> Void) = {_ in  }
    var totalResults = 0
    var movieViewModelList = [MovieViewModel]() {
        didSet {
            // Call the closure here to make view controller know about the update on movieViewModel list
            self.viewModelUpdates()
        }
    }
    
    func getMovies(networkManager: NetworkManager = NetworkManager()) {
        networkManager.getMovie() { result in
            switch result {
            case .success(let responseData):
                if let popularResult: PopularResult.Popular = JSONParser.decodeJson(from: responseData) {
                    if let movieList = popularResult.results?.map(MovieViewModel.init(movie:)) {
                        self.totalResults = Int(popularResult.totalResults ?? "0") ?? 0
                        self.movieViewModelList += movieList
                    }
                    else {
                        self.errorOccurred(.invalidData)
                    }
                }
                else {
                    self.errorOccurred(.invalidData)
                }
            case .failure(let error):
                self.errorOccurred(error)
            }
            
        }
    }
}
