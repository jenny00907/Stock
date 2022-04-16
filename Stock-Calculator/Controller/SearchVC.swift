//
//  ViewController.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/5/22.
//

import UIKit
import Combine
import MBProgressHUD

class SearchVC: UITableViewController, UIAnimatable {
    
    private enum Mode {
        case onboarding
        case search
    }
    
    
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
    
    @Published private var mode = Mode.onboarding
    @Published private var searchQuery = String()
    
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
        observeForm()
        
    }
    
    private
    func setUpNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search.. "
    }
    
    private
    func setUpTableView() {
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
    }
    
    private
    func observeForm() {
        
        $searchQuery
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                guard !searchQuery.isEmpty else { return }
                showLoadingAnimation()
                self.performSearch(with: searchQuery)
            }.store(in: &subscribers)
        
        $mode.sink { [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholder()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    private
    func performSearch(with query: String) {
        apiService.fetchSymbolsPublisher(keywords: query).sink { (completion) in
            self.hideLoadingAnimation()
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            case .finished: break
            }
        } receiveValue: { (searchResults) in
            self.searchResults = searchResults
            self.tableView.reloadData()
            self.tableView.isScrollEnabled = true
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let searchResults = searchResults {
            let symbol = searchResults.items[indexPath.item].symbol
            let searchResult = searchResults.items[indexPath.item]
            handleSelection(for: symbol, searchResult: searchResult)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
       
    }
    
    private
    func handleSelection(for symbol: String, searchResult: SearchResult) {
        showLoadingAnimation()
        apiService.fetchMonthlyAdjustedPublisher(keywords: symbol)
            .sink { (result) in
                self.hideLoadingAnimation()

                switch result {
                case .failure(let error):
                    print(error)
                case .finished: break
                }
            } receiveValue: { [weak self] (monthlyAdjusted) in
                print("Sucess \(monthlyAdjusted.getMonthlyInfo())")
                self?.hideLoadingAnimation()
                let asset = Asset(searchResult: searchResult, monthlyAdjusted: monthlyAdjusted)
                self?.performSegue(withIdentifier: "showCalculator", sender: asset)
                self?.searchController.searchBar.text = nil

            }.store(in: &subscribers)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalculator",
           let destination = segue.destination as? CalculatorTableVC,
           let asset = sender as? Asset {
            destination.asset = asset
        }
            
    }
    
}

extension SearchVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
                !searchQuery.isEmpty else { return }
        
        self.searchQuery = searchQuery
        
        
    }
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
}

