//
//  BaseViewController.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 19/05/24.
//

import UIKit

class BaseViewController: UIViewController {
    var loadingView: UIAlertController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func startLoder() {
        let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        alert.view.addSubview(indicator)
        loadingView = alert
        self.present(alert, animated: true)
    }
    
    func stopLoader() {
        loadingView?.dismiss(animated: true)
    }
    
}

// MARK: - Pull to Refresh
protocol PullToRefreshProtocol {
    func setupPullToRefresh(on tableView: UITableView)
    func pullToRefreshAction()
    
}
extension BaseViewController {
    @objc
    func triggerPullToRefresh(refreshControl: UIRefreshControl) {
        if let pullToRefreshController = self as? PullToRefreshProtocol {
            pullToRefreshController.pullToRefreshAction()
        }
        refreshControl.endRefreshing()
    }
}

extension PullToRefreshProtocol where Self: BaseViewController {
    func setupPullToRefresh(on tableView: UITableView) {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(red: 252, green: 60, blue: 0)
        refreshControl.addTarget(self, action: #selector(triggerPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.bounces = true
    }
}
