//
//  ExploreViewController.swift
//  PubCrawl
//
//  Created by Victor Cuc on 18/04/2021.
//

import UIKit

class ExploreHeaderView: UITableViewHeaderFooterView {
  static let reuseIdentifier = String(describing: ExploreHeaderView.self)
  @IBOutlet weak var titleLabel: UILabel!
}

class ExploreViewController: UITableViewController {
  enum Section: String, CaseIterable {
    case popular = "Popular"
    case community = "Community"
  }
  
  var dataSource: UITableViewDiffableDataSource<Section, Route>!
  var featuredRoutesViewController = FeaturedRoutesViewController.instantiateFromStoryboard()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: ExploreHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: ExploreHeaderView.reuseIdentifier)
    
    tableView.separatorStyle = .none
    
    configureDataSource()
    updateDataSource()
  }
  // MARK:- Delegate
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExploreHeaderView.reuseIdentifier) as! ExploreHeaderView
    view.titleLabel.text = Section.allCases[section].rawValue
    return view
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    60
  }
  
  // MARK:- Data Source
  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, route) -> UITableViewCell? in
      if indexPath == IndexPath(row: 0, section: 0) {
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
