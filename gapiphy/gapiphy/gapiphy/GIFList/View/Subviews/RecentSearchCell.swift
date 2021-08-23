//
//  RecentSearchCell.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 22/08/21.
//

import UIKit

class RecentSearchCell: UICollectionViewCell {
    
    static let identifier = String(describing: self)
    
    let text = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(text)
    }
    
    private func activateConstraints() {
        text.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: contentView.topAnchor),
            text.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            text.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
