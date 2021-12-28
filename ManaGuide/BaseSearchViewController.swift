//
//  BaseSearchViewController.swift
//  ManaGuide
//
//  Created by Jovito Royeca on 19/11/2018.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import PromiseKit

class BaseSearchViewController: BaseViewController {

    // MARK: Variables
    let searchController = UISearchController(searchResultsController: nil)
    var viewModel = BaseSearchViewModel()
    var showSearchController = true

    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!

    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if showSearchController {
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchResultsUpdater = self
            searchController.searchBar.delegate = self
            searchController.searchBar.placeholder = "Filter"
            definesPresentationContext = true
            
            if #available(iOS 11.0, *) {
                navigationItem.searchController = searchController
                navigationItem.hidesSearchBarWhenScrolling = false
            } else {
                tableView.tableHeaderView = searchController.searchBar
            }
        }
        tableView.keyboardDismissMode = .onDrag
        if let countLabel = countLabel {
            countLabel.text = " "
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showSearchController {
            if #available(iOS 11.0, *) {
                navigationItem.hidesSearchBarWhenScrolling = true
            }
        }
        
        if viewModel.mode == .loading {
            fetchData()
        }
    }
    
    // MARK: Custom methods
    @objc func doSearch() {
        viewModel.queryString = searchController.searchBar.text ?? ""
        
        if viewModel.queryString.isEmpty {
            if viewModel.isStandBy {
                viewModel.mode = .standBy
                tableView.reloadData()
                if let countLabel = countLabel {
                    countLabel.text = " "
                }
            } else {
                fetchData()
            }
        } else {
            fetchData()
        }
    }
    
    func fetchData() {
        viewModel.mode = .loading
        tableView.reloadData()
        if let countLabel = countLabel {
            countLabel.text = " "
        }

        firstly {
            viewModel.fetchData()
        }.done {
            self.viewModel.mode = self.viewModel.isEmpty() ? .noResultsFound : .resultsFound
            self.tableView.reloadData()
            if let countLabel = self.countLabel {
                countLabel.text = " \(self.viewModel.count()) cards"
            }
        }.catch { error in
            self.viewModel.mode = .error
            self.tableView.reloadData()
            if let countLabel = self.countLabel {
                countLabel.text = " "
            }
        }
    }
}

// MARK: UITableViewDataSource
extension BaseSearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(frame: CGRect.zero)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionIndexTitles()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionForSectionIndexTitle(title: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
    }
}

// MARK: UISearchResultsUpdating
extension BaseSearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doSearch), object: nil)
        perform(#selector(doSearch), with: nil, afterDelay: 0.5)
    }
}

// MARK: UISearchResultsUpdating
extension BaseSearchViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if viewModel.searchCancelled {
            searchBar.text = viewModel.queryString
        } else {
            viewModel.queryString = searchBar.text ?? ""
        }
    }
}
