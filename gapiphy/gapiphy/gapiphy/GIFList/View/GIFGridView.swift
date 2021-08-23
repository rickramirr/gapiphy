//
//  GIFGridView.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import UIKit
import Combine
import SDWebImageWebPCoder

class GIFGridView: UIViewController {
    
    var coordinator: MainCoordinator?
    
    var viewModel = GIFListViewModel()
    
    var gifsCancellable: AnyCancellable?
    
    var recentSearchesCancellable: AnyCancellable?
    
    var maxSavedSearchesCancellable: AnyCancellable?
    
    private let container = UIView()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private let gifCollection = GIFGrid()
    
    private let recentSearch = RecentSearchGrid()
    
    override func loadView() {
        super.loadView()
        configureNavigationBar()
        setupUI()
        activateConstraints()
        configureObservers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getGifsIfNeeded()
    }
    
    private func configureNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        title = "Gapiphy"
    }
    
    private func setupUI() {
        SDImageCodersManager.shared.addCoder(SDImageWebPCoder.shared)
        view.backgroundColor = .systemBackground
        view.addSubview(container)
        container.addSubview(searchBar)
        container.addSubview(gifCollection)
        container.addSubview(recentSearch)
        searchBar.delegate = self
        gifCollection.delegate = self
        recentSearch.delegate = self
        recentSearch.isHidden = true
    }
    
    private func activateConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: container.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        recentSearch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentSearch.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            recentSearch.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            recentSearch.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            recentSearch.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        gifCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gifCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            gifCollection.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gifCollection.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gifCollection.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
    
    private func configureObservers() {
        gifsCancellable = viewModel.$gifs
            .receive(on: DispatchQueue.main)
            .sink { gifs in
                self.gifCollection.updateUI(withGIFS: gifs)
            }
        recentSearchesCancellable = viewModel.$recentSearches
            .receive(on: DispatchQueue.main)
            .sink { recentSearches in
                self.recentSearch.updateUI(withRecentSearches: recentSearches)
            }
        maxSavedSearchesCancellable = viewModel.$maxSearch
            .receive(on: DispatchQueue.main)
            .sink { maxSavedSearch in
                self.recentSearch.updateUI(withMaxSavedSearches: maxSavedSearch)
            }
    }
    
}

extension GIFGridView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        recentSearch.isHidden = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              text != ""
            else {
            return
        }
        recentSearch.isHidden = true
        searchBar.resignFirstResponder()
        viewModel.searchGifs(withText: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        recentSearch.isHidden = true
        viewModel.finishSearch()
    }
    
}

extension GIFGridView: GIFCollectionDelegate {
    
    func willDisplayLastItem() {
        viewModel.getGifsIfNeeded()
    }
    
    func didSelectGIF(_ gif: GIF) {
        coordinator?.viewGIFDetail(gif)
    }
    
}

extension GIFGridView: RecentSearchGridDelegate {
    
    func didUpdateMaxSearch(_ value: Int) {
        viewModel.updateMaxSearch(value)
    }
    
    func didSelectSearch(_ text: String) {
        searchBar.text = text
    }
    
    
}
