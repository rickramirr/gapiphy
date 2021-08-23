//
//  GIFCell.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 21/08/21.
//

import UIKit
import SDWebImage
import SDWebImageWebPCoder

class GIFCell: UICollectionViewCell {
    
    static let identifier = String(describing: self)
    
    let imageView = SDAnimatedImageView()
    
    var videoURL: String? {
        didSet {
            configureCell()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        activateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .blue
        contentView.addSubview(imageView)
        imageView.shouldIncrementalLoad = true
    }
    
    private func activateConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureCell() {
        guard let videoURL = videoURL,
              let url = URL(string: videoURL)
            else {
            return
        }
        imageView.sd_setImage(with: url, placeholderImage: nil, options: [.progressiveLoad])
    }
    
}
