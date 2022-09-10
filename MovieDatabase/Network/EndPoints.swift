import Foundation

enum EndPoints {
    case Popular
}

extension EndPoints {
    
    var path: String {
        
        let baseURL = "https://api.themoviedb.org/3"
        
        struct Section {
            static let Popular = "/movie/popular"
        }
        
        switch(self) {
        case .Popular:
            return "\(baseURL)\(Section.Popular)"
        }
    }
    
}

