import UIKit

class MovieCell: UITableViewCell {
    @IBOutlet weak var poster: CachedImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var playlist: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with viewModel: MovieViewModel){
        self.title.text = viewModel.title;
        self.rating.text = viewModel.rating
        self.poster.loadImage(placeHolder: #imageLiteral(resourceName: "poster"),  urlString: viewModel.imageURL)
        self.playlist.text = viewModel.playlist;
    }
}
