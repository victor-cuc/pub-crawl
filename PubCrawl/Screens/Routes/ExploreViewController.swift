//
//  ExploreViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 18/04/2021.
//

import UIKit

class ExploreViewController: UITableViewController {
  enum Section: Int {
    case popular
    case community
  }
  
  var dataSource: UITableViewDiffableDataSource<Section, Route>!
  var featuredRoutesViewController = FeaturedRoutesViewController.instantiateFromStoryboard()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataSource()
    updateDataSource()
  }
  
  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, route) -> UITableViewCell? in
      if indexPath.section == Section.popular.rawValue {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedRoutesCell", for: indexPath)
        self.embedChildViewController(self.featuredRoutesViewController, in: cell)
        return cell
      }
      return nil
    }
  }
  
  func updateDataSource() {
    var newSnapshot = NSDiffableDataSourceSnapshot<Section, Route>()
    newSnapshot.appendSections([.popular])
    newSnapshot.appendItems([Route(id: "111", data: [:])], toSection: .popular)
    dataSource.apply(newSnapshot, animatingDifferences: true)
  }
  
  func embedChildViewController(_ viewController: UIViewController, in view: UIView) {
    viewController.willMove(toParent: self)
    self.addChild(viewController)
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    view.addSubview(viewController.view)
    viewController.didMove(toParent: self)
  }
}
