
import UIKit

class ViewController: UIViewController {
    private var moviewListViewModel: MovieViewModelList?
    private let networkManager: NetworkManager = NetworkManager(session: URLSession.shared)
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        getMovies()
    }

    private func getMovies() {
        if self.moviewListViewModel == nil {
            self.moviewListViewModel = MovieViewModelList()
            self.moviewListViewModel?.viewModelUpdates = { [unowned self] in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            self.moviewListViewModel?.errorOccurred = { [unowned self] error in
                DispatchQueue.main.async {
                    //Show error message and reload table.
                    let alert = UIAlertController(title: "Error", message: "Error in API", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.tableView.reloadData()
                }
            }
        }
        self.moviewListViewModel?.getMovies()
    }

}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviewListViewModel?.movieViewModelList.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieCellId") as? MovieCell {
            if let movie = (moviewListViewModel?.movieViewModelList[indexPath.row]) {
                cell.configureCell(with: movie)
            }
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Do nothing
    }
}

