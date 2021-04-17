//
//  RoutesViewControlle.swift
//  PubCrawl
//
//  Created by Victor Cuc on 09/04/2021.
//

import UIKit
import FirebaseAuth

class RoutesViewController: UIViewController {
  
  enum Section {
    case community
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Route>!
  private var routes: [Route] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = Auth.auth().currentUser {
      print("Viewing routes for user: \(user)")
      setUpView()
    }
  }
  func setUpView() {
    self.title = "Routes"
    
    FirebaseManager.fetchAllRoutes(completion: { (routes) in
      print("Routes: \(routes)")
      for routeDiff in routes.difference(from: self.routes) {
        print(routeDiff)
      }
      self.routes = routes
      self.configureSnapshot()
    })
    self.collectionView.collectionViewLayout = self.configureCollectionViewLayout()
//    collectionView.delegate = self
    self.configureDataSource()
  }
  
  class func instantiateFromStoryboard() -> RoutesViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "RoutesViewController") as! RoutesViewController
    
    return viewController
  }
}
// MARK: - Collection View -

extension RoutesViewController {
  func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - Diffable Data Source -

extension RoutesViewController {
  typealias RouteDataSource = UICollectionViewDiffableDataSource<Section, Route>
  
  func configureDataSource() {
    dataSource = RouteDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, route: Route) -> UICollectionViewCell? in
     
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteCell.reuseIdentifier, for: indexPath) as? RouteCell else {
        return nil
      }
      
      cell.nameLabel.text = route.name
      
      return cell
    }
  }
  
  func configureSnapshot() {
    var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Route>()
    currentSnapshot.appendSections([.community])
    currentSnapshot.appendItems(routes)
    
    dataSource.apply(currentSnapshot, animatingDifferences: true)
  }
  // MARK: - Get Routes -
//  private func getAllRoutes(completion: @escaping () -> Void) {
//  }
}

