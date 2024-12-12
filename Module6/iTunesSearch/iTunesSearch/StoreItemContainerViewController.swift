
import UIKit

class StoreItemContainerViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet var tableContainerView: UIView!
    @IBOutlet var collectionContainerView: UIView!
    
    
    var tableViewDataSource: UITableViewDiffableDataSource<String, StoreItem>!
    
    let searchController = UISearchController()
    let storeItemController = StoreItemController()
    
    var collectionViewDataSource: UICollectionViewDiffableDataSource<String, StoreItem>!
    
    var items = [StoreItem]()
    
    var itemsSnapshot: NSDiffableDataSourceSnapshot<String, StoreItem> {
        var snapshot = NSDiffableDataSourceSnapshot<String, StoreItem>()
        
        snapshot.appendSections(["Results"])
        snapshot.appendItems(items)
        
        return snapshot
    }

    let queryOptions = ["movie", "music", "software", "ebook"]
    
    // keep track of async tasks so they can be cancelled if appropriate.
    var searchTask: Task<Void, Never>? = nil
    var tableViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    var collectionViewImageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["Movies", "Music", "Apps", "Books"]
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchMatchingItems), object: nil)
        perform(#selector(fetchMatchingItems), with: nil, afterDelay: 0.3)
    }
    
    func configureTableViewDataSource(_ tableView: UITableView) {
        tableViewDataSource = UITableViewDiffableDataSource<String, StoreItem>(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
                let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
                
                // Cancel any existing image load task
                self.tableViewImageLoadTasks[indexPath]?.cancel()
                
                // Start a new task using the protocol's configuration method
                self.tableViewImageLoadTasks[indexPath] = Task {
                    await cell.configure(for: item, storeItemController: self.storeItemController)
                    self.tableViewImageLoadTasks[indexPath] = nil
                }
                
                return cell
            }
        )
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableViewController = segue.destination as? StoreItemListTableViewController {
            configureTableViewDataSource(tableViewController.tableView)
        } else if let collectionViewController = segue.destination as? StoreItemCollectionViewController {
            // Pass the existing storeItemController
            collectionViewController.storeItemController = self.storeItemController
            collectionViewController.configureCollectionViewDataSource(collectionViewController.collectionView)
        }
    }

                
    @IBAction func switchContainerView(_ sender: UISegmentedControl) {
        tableContainerView.isHidden.toggle()
        collectionContainerView.isHidden.toggle()
    }
    
    @objc func fetchMatchingItems() {
        // Cancel any image loading tasks that are still running
        collectionViewImageLoadTasks.values.forEach { task in
            task.cancel()
        }
        collectionViewImageLoadTasks = [:]

        tableViewImageLoadTasks.values.forEach { task in
            task.cancel()
        }
        tableViewImageLoadTasks = [:]
        
        self.items = []
        
        let searchTerm = searchController.searchBar.text ?? ""
        let mediaType = queryOptions[searchController.searchBar.selectedScopeButtonIndex]
        
        // cancel existing task since we will not use the result
        searchTask?.cancel()
        searchTask = Task {
            if !searchTerm.isEmpty {
                // set up query dictionary
                let query = [
                    "term": searchTerm,
                    "media": mediaType,
                    "lang": "en_us",
                    "limit": "20"
                ]
                
                // use the item controller to fetch items
                do {
                    let items = try await storeItemController.fetchItems(matching: query)
                    if searchTerm == self.searchController.searchBar.text &&
                       mediaType == queryOptions[searchController.searchBar.selectedScopeButtonIndex] {
                        self.items = items
                        print("Fetched items: \(items)")  // Debug print
                    }
                } catch let error as NSError where error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                    // ignore cancellation errors
                } catch {
                    print(error)
                }
            }
            
            // Apply the snapshot to the tableView data source
            await tableViewDataSource.apply(itemsSnapshot, animatingDifferences: true)
            await collectionViewDataSource.apply(itemsSnapshot, animatingDifferences: true)

            searchTask = nil
        }
        
    }

    
}
