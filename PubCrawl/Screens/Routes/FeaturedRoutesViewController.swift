//
//  RoutesViewControlle.swift
//  PubCrawl
//
//  Created by Victor Cuc on 09/04/2021.
//

import UIKit
import FirebaseAuth

class FeaturedRoutesViewController: UIViewController {
  
  enum Section {
    case allRoutes
  }
  
  @IBOutlet weak var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Section, Route>!
  private var routes: [Route] = []
  
  class func instantiateFromStoryboard() -> FeaturedRoutesViewController {
    let storyboard = UIStoryboard(name: "Routes", bundle: nil)
    let viewController = storyboard.instantiateViewController(identifier: "FeaturedRoutesViewController") as! FeaturedRoutesViewController
    
    return viewController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let user = Auth.auth().currentUser {
      print("Viewing routes for user: \(user)")
      setUpView()
    }
  }
  
  func setUpView() {
    
    FirebaseManager.fetchAllRoutes(completion: { (routes) in
      print("Routes: \(routes)")
      let popularRoutes = routes.sorted(by: { $0.starredBy.count > $1.starredBy.count })
      
      self.routes = Array(popularRoutes.prefix(5))
      self.configureSnapshot()
    })
    collectionView.collectionViewLayout = self.configureCollectionViewLayout()
    collectionView.delegate = self
    configureDataSource()
  }
}
// MARK: - Collection View -

extension FeaturedRoutesViewController {
  func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(1.0))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
    section.orthogonalScrollingBehavior = .groupPaging
    
    return UICollectionViewCompositionalLayout(section: section)
  }
}

// MARK: - Diffable Data Source -

extension FeaturedRoutesViewController {
  typealias RouteDataSource = UICollectionViewDiffableDataSource<Section, Route>
  
  func configureDataSource() {
    dataSource = RouteDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, route: Route) -> UICollectionViewCell? in
     
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RouteCell.reuseIdentifier, for: indexPath) as? RouteCell else {
        return nil
      }
      
      cell.starButton.isSelected = route.isStarredByCurrentUser()
      cell.actionDelegate = self
      cell.nameLabel.text = route.name
      cell.starCount.text = String(route.starredBy.count)
      cell.locationCount.text = String(route.locationIDs.count)
      cell.imageView.loadImageFromFirebase(reference: route.imageRef, placeholder: UIImage(named: "placeholderRouteThumbnail"))
  
      return cell
    }
  }
  
  func configureSnapshot() {
    var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Route>()
    currentSnapshot.appendSections([.allRoutes])
    currentSnapshot.appendItems(routes)
    
    dataSource.apply(currentSnapshot, animatingDifferences: true)
  }
}
  // MARK: - RouteCellActionDelegate -
extension FeaturedRoutesViewController: RouteCellActionDelegate {
  func toggleStarAction(cell: RouteCell) {
    if let indexPath = collectionView.indexPath(for: cell) {
      let route = routes[indexPath.item]
      FirebaseManager.toggleRouteStar(route: route)
    }
  }
}


extension FeaturedRoutesViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("item pressed")
    if let route = dataSource.itemIdentifier(for: indexPath) {
      let routeDetailViewController = RouteDetailTableViewController.instantiateFromStoryboard(route: route)
      navigationController?.pushViewController(routeDetailViewController, animated: true)
    }
  }
}


