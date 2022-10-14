//
//  ViewController.swift
//  GalaxyExplorer
//
//  Created by A118830248 on 14/10/22.
//

import UIKit
var rowHeights: [String: CGFloat] = [:]

class GalaxyExplorerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PlanetViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            viewModel  = PlanetViewModel(service: GalaxyService())
        }
        setupBinding()
        self.title = "Explorer"
        setupTableView()
        viewModel?.getImages(count: 10)
    }
    
    private func setupBinding() {
        viewModel?.reloadCallBack = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel?.errorMessage = { [weak self] message in
            self?.tableView.refreshControl?.endRefreshing()
            self?.showAlert(title: "Error", message: message)
        }
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }
}

extension GalaxyExplorerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.dataSource.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: GalaxyTableViewCell.self), for: indexPath) as! GalaxyTableViewCell
        cell.details = viewModel?.dataSource[indexPath.row]
        cell.reloadCallBack = {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        return cell
    }
}

extension GalaxyExplorerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let url = viewModel?.dataSource[indexPath.row].hdurl,
           let height = rowHeights[url] {
            return height
        } else {
            return 320
        }
    }
}
