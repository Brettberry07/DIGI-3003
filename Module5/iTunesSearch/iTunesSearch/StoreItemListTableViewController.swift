
import UIKit

@MainActor
class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var filterSegmentedControl: UISegmentedControl!
    
    // add item controller property
    
    var items = [StoreItem]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
    var storeItemController = StoreItemController()
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fetchMatchingItems() {
        
        self.items = []
        self.tableView.reloadData()
        
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentedControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            // set up query dictionary
            let searchQuery: [String: String] = [
                "term": searchTerm,
                "media": mediaType,
                "limit": "25",
                "lang": "en_us"
            ]
            
            // use the item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise, print an error to the console
            Task{
                do{
                    let storeItems = try await self.storeItemController.fetchItems(matching: searchQuery)
                    
                    DispatchQueue.main.async{
                        self.items = storeItems
                        self.tableView.reloadData()
                    }
                }
                catch{
                    print("Falied to fetch data, error: \(error)")
                }
            }
        }
    }
    
    func configure(cell: ItemCell, forItemAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        // set cell.name to the item's name
        cell.name = item.name
        
        
        // set cell.artist to the item's artist
        cell.artist = item.artist
        
        // set cell.artworkImage to nil
        cell.artworkImage = nil
        
        //cancellign nay task that areayd exists in this index
        imageLoadTasks[indexPath]?.cancel()
        
        // initialize a network task to fetch the item's artwork keeping track of the task
        // in imageLoadTasks so they can be cancelled if the cell will not be shown after
        // the task completes.
        //
        // if successful, set the cell.artworkImage using the returned image
        let task = Task{
            do{
                let (data, _) = try await URLSession.shared.data(from: item.artworkURL)
                if  !Task.isCancelled, let image = UIImage(data: data){
                    DispatchQueue.main.async{
                        cell.artworkImage = image
                    }
                }
            }
            catch{
                print("Error finding image: \(error)")
            }
            //finished the task so get rid of it
            imageLoadTasks[indexPath] = nil
        }
        //store the task for later cancellation
        imageLoadTasks[indexPath] = task
        
        
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        
        fetchMatchingItems()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemCell
        configure(cell: cell, forItemAt: indexPath)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // cancel the image fetching task if we no longer need it
        imageLoadTasks[indexPath]?.cancel()
    }
}

extension StoreItemListTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}

