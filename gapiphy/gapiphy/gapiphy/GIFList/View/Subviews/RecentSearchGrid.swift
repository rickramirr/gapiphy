//
//  RecentSearchGrid.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 22/08/21.
//

import UIKit

protocol RecentSearchGridDelegate: AnyObject {
    func didUpdateMaxSearch(_ value: Int)
    func didSelectSearch(_ text: String)
}

class RecentSearchGrid: UIView {
    
    weak var delegate: RecentSearchGridDelegate?
    
    private var dataSource: UICollectionViewDiffableDataSource<RecentSearchSection,String>?
    
    private enum RecentSearchSection: CaseIterable {
        case all
    }
    
    private let title = UILabel()
    
    private let searchNumber = UILabel()
    
    private let stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.value = 1
        return stepper
    }()
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        activateConstraints()
        configureCollection()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .systemBackground
        title.text = "Recent searches"
        stepper.addTarget(self, action: #selector(onStepperChangeValue(_:)), for: .valueChanged)
        addSubview(title)
        addSubview(searchNumber)
        addSubview(stepper)
        addSubview(collection)
    }
    
    private func activateConstraints() {
        stepper.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stepper.topAnchor.constraint(equalTo: topAnchor),
            stepper.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        searchNumber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchNumber.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            searchNumber.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -5),
        ])
        
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 10),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func configureCollection() {
        self.dataSource = makeDataSource()
        collection.dataSource = dataSource
        collection.register(RecentSearchCell.self, forCellWithReuseIdentifier: RecentSearchCell.identifier)
        collection.delegate = self
    }
    
    @objc func onStepperChangeValue(_ sender: UIStepper) {
        delegate?.didUpdateMaxSearch(Int(sender.value))
    }
    
    func updateUI(withRecentSearches recentSearches: [String]) {
        var snapshot = NSDiffableDataSourceSnapshot<RecentSearchSection,String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(recentSearches)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func updateUI(withMaxSavedSearches maxSavedSearches: Int) {
        stepper.value = Double(maxSavedSearches)
        searchNumber.text = "\(maxSavedSearches)"
    }
    
}

extension RecentSearchGrid: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let search = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        delegate?.didSelectSearch(search)
    }
    
}

private extension RecentSearchGrid {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<RecentSearchSection,String> {
        return UICollectionViewDiffableDataSource<RecentSearchSection,String>(collectionView: collection) { (collection, indexPath, recentSearch) -> UICollectionViewCell in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: RecentSearchCell.identifier, for: indexPath) as! RecentSearchCell
            cell.text.text = recentSearch
            return cell
        }
    }
    
}
