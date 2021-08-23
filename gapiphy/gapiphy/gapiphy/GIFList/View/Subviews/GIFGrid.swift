//
//  GIFGrid.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 22/08/21.
//

import UIKit

protocol GIFCollectionDelegate: AnyObject {
    func willDisplayLastItem()
    func didSelectGIF(_ gif: GIF)
}

class GIFGrid: UIView {
    
    private enum GIFSection: CaseIterable {
        case all
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<GIFSection,GIF>?
    
    weak var delegate: GIFCollectionDelegate?
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
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
        addSubview(collection)
    }
    
    private func activateConstraints() {
        collection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func configureCollection() {
        self.dataSource = makeDataSource()
        collection.dataSource = dataSource
        collection.register(GIFCell.self, forCellWithReuseIdentifier: GIFCell.identifier)
        collection.delegate = self
    }
    
    func updateUI(withGIFS gifs: [GIF]) {
        var snapshot = NSDiffableDataSourceSnapshot<GIFSection,GIF>()
        snapshot.appendSections([.all])
        snapshot.appendItems(gifs)
        dataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
}

extension GIFGrid: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let gif = dataSource?.itemIdentifier(for: indexPath),
              let width = Int(gif.images.fixedHeightSmall?.width ?? ""),
              let height = Int(gif.images.fixedHeightSmall?.height ?? "")
            else {
            return .zero
        }
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            delegate?.willDisplayLastItem()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let gif = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        delegate?.didSelectGIF(gif)
    }
    
}

private extension GIFGrid {
    
    private func makeDataSource() -> UICollectionViewDiffableDataSource<GIFSection,GIF> {
        return UICollectionViewDiffableDataSource<GIFSection,GIF>(collectionView: collection) { (collection, indexPath, gif) -> UICollectionViewCell in
            let cell = collection.dequeueReusableCell(withReuseIdentifier: GIFCell.identifier, for: indexPath) as! GIFCell
            cell.videoURL = gif.images.fixedHeightSmall?.webp
            return cell
        }
    }
    
}
