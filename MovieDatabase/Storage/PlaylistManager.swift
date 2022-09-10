
import Foundation
import CoreData


protocol PlaylistProtocol {
    func createPlaylist(name: String)
    func addMovieToPlaylist(playlist: Playlist, movieName: String)
    func getPlaylist() -> [Playlist]
}

class PlaylistManager : PlaylistProtocol {
    var databaseOperation: DatabaseOperation
    
    init(databaseOpration: DatabaseOperation){
        self.databaseOperation = databaseOpration
    }
    
    
    func createPlaylist(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Playlist",
                                                in: databaseOperation.persistentContainer.viewContext)!
        let playlist = Playlist(entity: entity, insertInto:databaseOperation.persistentContainer.viewContext)
        playlist.name = name
        try! databaseOperation.persistentContainer.viewContext.save()
    }
    
    func addMovieToPlaylist(playlist: Playlist, movieName: String) {
        let movie = createMovieEntity(context: databaseOperation.persistentContainer.viewContext, movieName: movieName)
        playlist.addToMovies(movie)
        movie.playlist = playlist
        try! databaseOperation.persistentContainer.viewContext.save()
    }
    
    func getPlaylist() -> [Playlist] {
        let fetchRequest =  Playlist.fetchRequest()
        return databaseOperation.executeFetch(fetchRequest)
    }
    private func createMovieEntity(context: NSManagedObjectContext, movieName: String) -> Movie {
        let entity = NSEntityDescription.entity(forEntityName: "Movie",
                                                in: context)!
        let movie = Movie(entity: entity, insertInto:context)
        movie.name = movieName
        return movie
    }
}
