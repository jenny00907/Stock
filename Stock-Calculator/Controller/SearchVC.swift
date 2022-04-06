//
//  ViewController.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/5/22.
//

import UIKit
import Combine

class SearchVC: UITableViewController {
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    private let apiService = APIService()
    private var searchResults: SearchResults?
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        observeForm()
        
    }
    
    private
    func setUpNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private
    func observeForm() {
        
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                self.performSearch(with: searchQuery)
            }.store(in: &subscribers)
    }
    
    private
    func performSearch(with query: String) {
        apiService.fetchSymbolsPublisher(keywords: query).sink { (completion) in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { (searchResults) in
            self.searchResults = searchResults
            self.tableView.reloadData()
            //print(searchResults)
        }.store(in: &subscribers)

    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SearchCell
        if let searchResults = self.searchResults {
            let searchResults = searchResults.items[indexPath.row]
            cell.configure(with: searchResults)
        }
        return cell
    }
}

extension SearchVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
                !searchQuery.isEmpty else { return }
        
        self.searchQuery = searchQuery
        
        
    }
    
}

