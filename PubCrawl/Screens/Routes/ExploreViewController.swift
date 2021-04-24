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
  
  var dataSource: UITableViewDiffableDataSource<Section, Post>!
  let featuredRoutesViewController = FeaturedRoutesViewController.instantiateFromStoryboard()
  var posts: [Post] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UINib(nibName: ExploreHeaderView.reuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: ExploreHeaderView.reuseIdentifier)
    tableView.separatorStyle = .none
    
    FirebaseManager.getAllPosts { posts, error in
      self.posts = posts
      self.updateDataSource()
    }
    configureDataSource()
  }
  
  // MARK:- Delegate
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExploreHeaderView.reuseIdentifier) as! ExploreHeaderView
    view.titleLabel.text = Section.allCases[section].rawValue
    return view
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    50
  }
  
  // MARK:- Data Source
  func configureDataSource() {
    typealias PostDataSource = UITableViewDiffableDataSource<Section, Post>
    
    dataSource = PostDataSource(tableView: tableView) {
      (tableView: UITableView, indexPath: IndexPath, post: Post) -> UITableViewCell? in
      
      if indexPath == IndexPath(row: 0, section: 0) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeaturedRoutesCell", for: indexPath)
        self.embedChildViewController(self.featuredRoutesViewController, in: cell)
        return cell
      }
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PostCell.self)", for: indexPath) as? PostCell else {
        fatalError("Could not create PostCell")
      }
      
      cell.actionDelegate = self
      
      cell.usernameLabel.text = post.user?.username
      cell.profilePicture.loadImageFromFirebase(reference: post.user?.profilePictureRef, placeholder: UIImage(named: "placeholderProfile"))
      cell.timestampLabel.text = post.createdAt.timeAgoDisplay()
      cell.postTextLabel.text = post.text
      
      cell.postImageContainer.isHidden = post.imageRefs.isEmpty
      cell.postImageView2.isHidden = post.imageRefs.count == 1
      cell.postImageView1.loadImageFromFirebase(reference: post.imageRefs.first)
      cell.postImageView2.loadImageFromFirebase(reference: post.imageRefs.last)
      
      cell.routeNameLabel.text = post.route.name
      cell.routeImageView.loadImageFromFirebase(reference: post.route.imageRef, placeholder: UIImage(named: "placeholderRouteThumbnail"))
      cell.routeLocationCount.text = String(post.route.locationIDs.count)
      cell.routeStarButton.isSelected = post.route.isStarredByCurrentUser()
      cell.routeStarCount.text = String(post.route.starredBy.count)
      
      return cell
    }
  }
  
  func updateDataSource() {
    var newSnapshot = NSDiffableDataSourceSnapshot<Section, Post>()
    
    newSnapshot.appendSections([.popular])
    newSnapshot.appendItems([Post(id: "Dummy Post for Featured Section", data: [:])], toSection: .popular)
    
    newSnapshot.appendSections([.community])
    newSnapshot.appendItems(posts)
    
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

extension ExploreViewController: PostCellActionDelegate {
  
  func toggleStarAction(cell: PostCell) {
    print("star action table delegate")
    if let indexPath = tableView.indexPath(for: cell) {
      let post = posts[indexPath.item]
      guard let route = post.route else { return }
      print(route.name)
      FirebaseManager.toggleStar(forRoute: route)
    }
  }
}

//MARK:- Date extension - Time ago
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
