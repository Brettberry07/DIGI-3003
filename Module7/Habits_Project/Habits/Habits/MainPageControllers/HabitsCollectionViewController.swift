////
////  HabitsCollectionViewController.swift
////  Habits
////
////  Created by Berry, Brett A. (Student) on 12/5/24.
////
//
//import UIKit
//
//private let reuseIdentifier = "Cell"
//
//class HabitsCollectionViewController: UICollectionViewController {
//    
//    //data models and etc
//    
//    typealias DataSourceType =
//    UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
//    
//    enum ViewModel {
//        enum Section: Hashable, Comparable {
//            case favorites
//            case category(_ category: Category)
//            
//            static func < (lhs: Section, rhs: Section) -> Bool {
//                switch (lhs, rhs) {
//                case (.category(let l), .category(let r)):
//                    return l.name < r.name
//                case (.favorites, _):
//                    return true
//                case (_, .favorites):
//                    return false
//                }
//            }
//        }
//        
//        typealias Item = Habit
//    }
//
//    
//    
//    enum Section: Hashable, Comparable {
//        case favorites
//        case category(_ category: Category)
//    
//        static func < (lhs: Section, rhs: Section) -> Bool {
//            switch (lhs, rhs) {
//            case (.category(let l), .category(let r)):
//                return l.name < r.name
//            case (.favorites, _):
//                return true
//            case (_, .favorites):
//                return false
//            }
//        }
//    }
//    
//    struct Model {
//        var habitsByName = [String: Habit]()
//        var favoriteHabits: [Habit] {
//            return Settings.shared.favoriteHabits
//        }
//    }
//
//    
//    //variables
//    
//    var dataSource: DataSourceType!
//    var model = Model()
//    var sectionIDs: [ViewModel.Section] {
//        itemsBySection.keys.sorted()
//    }
//
//    
//    // Keep track of async tasks so they can be cancelled when appropriate
//    var habitsRequestTask: Task<Void, Never>? = nil
//    deinit { habitsRequestTask?.cancel() }
//    
//    //closures and computed
//    var itemsBySection: [ViewModel.Section: [ViewModel.Item]] {
//        model.habitsByName.values.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { partial, habit in
//            let item = habit
//            
//            let section: ViewModel.Section
//            if model.favoriteHabits.contains(habit) {
//                section = .favorites
//            } else {
//                section = .category(habit.category)
//            }
//            
//            partial[section, default: []].append(item)
//        }
//    }
//
//    
//    
//    //overrides
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        dataSource = createDataSource()
//        collectionView.dataSource = dataSource
//        collectionView.collectionViewLayout = createLayout()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    
//        update()
//    }
//    
//    //funcs
//    func update() {
//        habitsRequestTask?.cancel()
//        habitsRequestTask = Task {
//            if let habits = try? await HabitRequest().send() {
//                self.model.habitsByName = habits
//            } else {
//                self.model.habitsByName = [:]
//            }
//            self.updateCollectionView()
//
//            habitsRequestTask = nil
//        }
//    }
//    
//    
//    func updateCollectionView() {
//        dataSource.applySnapshotUsing(sectionIDs: sectionIDs,
//           itemsBySection: itemsBySection)
//    }
//    
//    func createDataSource() -> DataSourceType {
//        let dataSource = DataSourceType(collectionView: collectionView) {
//           (collectionView, indexPath, item) in
//            let cell =
//               collectionView.dequeueReusableCell(withReuseIdentifier:
//               "Habit", for: indexPath) as! UICollectionViewListCell
//    
//            var content = cell.defaultContentConfiguration()
//            content.text = item.name
//            cell.contentConfiguration = content
//    
//            return cell
//        }
//    
//        return dataSource
//    }
//    
//    func createLayout() -> UICollectionViewCompositionalLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//    
//        let groupSize =
//           NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//           heightDimension: .absolute(44))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize:
//           groupSize, subitem: item, count: 1)
//    
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
//           leading: 10, bottom: 0, trailing: 10)
//    
//        return UICollectionViewCompositionalLayout(section: section)
//    }
//    
//    //segues and actions
//    
//}

//
//  HabitCollectionViewController.swift
//  Habits
//
//  Created by Hunter, Chloe Mikhayla A. (Student) on 12/5/24.
//

import UIKit

private let reuseIdentifier = "Cell"


class HabitCollectionViewController: UICollectionViewController {
    var habitsRequestTask: Task<Void, Never>? = nil
    deinit { habitsRequestTask?.cancel() }
    
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>

    enum ViewModel {
        enum Section: Hashable, Comparable {
            case favorites
            case category(_ category: Category)
        
            static func < (lhs: Section, rhs: Section) -> Bool {
                switch (lhs, rhs) {
                case (.category(let l), .category(let r)):
                    return l.name < r.name
                case (.favorites, _):
                    return true
                case (_, .favorites):
                    return false
                }
            }
        }
        typealias Item = Habit
    }

    struct Model {
        var habitsByName = [String: Habit]()
        var favoriteHabits: [Habit] {
            return Settings.shared.favoriteHabits
        }
    }

    var dataSource: DataSourceType!
    var model = Model()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        
        
        
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "Habit")
    }
    
    func update() {
        habitsRequestTask?.cancel()
        habitsRequestTask = Task {
            if let habits = try? await HabitRequest().send() {
                self.model.habitsByName = habits
            } else {
                self.model.habitsByName = [:]
            }
            self.updateCollectionView()
    
            habitsRequestTask = nil
        }
    }
    
    func updateCollectionView() {
        
        let itemsBySection = model.habitsByName.values.reduce(into: [ViewModel.Section: [ViewModel.Item]]())
        { partial, habit in
            let item = habit
        
            let section: ViewModel.Section
            if model.favoriteHabits.contains(habit) {
                section = .favorites
            } else {
                section = .category(habit.category)
            }
        
            partial[section, default: []].append(item)
        }
        let sectionIDs = itemsBySection.keys.sorted()
        
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
    
        
    }
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) {
           (collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Habit", for: indexPath) as! UICollectionViewListCell
    
            var content = cell.defaultContentConfiguration()
            content.text = item.name
            cell.contentConfiguration = content
            
            return cell
        }
    
        return dataSource
    }
    
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
    
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        update()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

