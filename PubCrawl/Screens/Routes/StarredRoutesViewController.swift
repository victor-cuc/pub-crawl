//
//  RoutesViewControlle.swift
//  PubCrawl
//
//  Created by Victor Cuc on 09/04/2021.
//

import UIKit
import FirebaseAuth

class StarredRoutesViewController: UIViewController {
  
  enum Section {
    case saved
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Route>!
  private var routes: [Route] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if Auth.auth().currentUser != nil {
      setUpView()
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    fetchRoutes()
  }
  
  func setUpView() {
    self.title = "Saved"
    
    configureRefreshControl()
    fetchRoutes()
    collectionView.collectionViewLayout = self.configureCollectionViewLayout()
    collectionView.delegate = self
    configureDataSource()
  }
  
  func fetchRoutes() {
    FirebaseManager.getAllRoutes(completion: { (routes) in
      self.routes = routes.filter { $0.isStarredByCurrentUser() }
      self.configureSnapshot()
    })
  }
  
  func configureRefreshControl() {
    collectionView.refreshControl = UIRefreshControl()
    collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
  }
  
  @objc func handleRefreshControl() {
    fetchRoutes()
    DispatchQueue.main.async {
      self.collectionView.refreshControl?.endRefreshing()
    }
  }
}
// MARK: - Collection View -

extension StarredRoutesViewController {
  func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.25))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - Diffable Data Source -

extension StarredRoutesViewController {
  typealias RouteDataSource = UICollectionViewDiffableDataSource<Section, Route>
  
  func configureDataSource() {
    dataSource = RouteDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, route: Route) -> UICollectionViewCell? in
     
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteCell.reuseIdentifier, for: indexPath) as? RouteCell else {
        return nil
      }
      
      cell.actionDelegate = self
      cell.configureWith(route: route)
  
      return cell
    }
  }
  
  func configureSnapshot() {
    var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Route>()
    currentSnapshot.appendSections([.saved])
    currentSnapshot.appendItems(routes)
    
    dataSource.apply(currentSnapshot, animatingDifferences: true)
  }
}
  // MARK: - RouteCellActionDelegate -
extension StarredRoutesViewController: RouteCellActionDelegate {
  func toggleStarAction(cell: RouteCell) {
    if let indexPath = collectionView.indexPath(for: cell) {
      let route = routes[indexPath.item]
      FirebaseManager.toggleStar(forRoute: route) {
        cell.configureWith(route: route)
      }
    }
  }
}

extension StarredRoutesViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("item pressed")
    if let route = dataSource.itemIdentifier(for: indexPath) {
      let routeDetailViewController = RouteDetailTableViewController.instantiateFromStoryboard(route: route)
      navigationController?.pushViewController(routeDetailViewController, animated: true)
    }
  }
}

