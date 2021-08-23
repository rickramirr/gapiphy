//
//  GIFDetailView.swift
//  gapiphy
//
//  Created by Ricardo Ramirez on 22/08/21.
//

import UIKit
import AVFoundation

class GIFDetailView: UIViewController {
    
    var coordinator: MainCoordinator?
    
    var gif: GIF?
    
    var playerLooper: AVPlayerLooper?
    var playerLayer: AVPlayerLayer?
    var queuePlayer: AVQueuePlayer?
    
    let container = UIView()
    
    let avatar = UIImageView()
    
    let userNameLabel = UILabel()
    
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 5
        return stack
    }()
    
    let titleLabel = UILabel()
    
    let originalWidthLabel = UILabel()
    
    let originalHeightLabel = UILabel()
    
    let amountFramesLabel = UILabel()
    
    let video = UIView()
    
    override func loadView() {
        super.loadView()
        setupUI()
        activateConstraints()
        guard let gif = gif else {
            return
        }
        updateUI(withGIF: gif)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if playerLayer == nil {
            guard let gif = gif else {
                return
            }
            playVideo(withUrl: gif.images.original.mp4)
        }
    }
    
    private func setupUI() {
        title = "Details"
        view.backgroundColor = .systemBackground
        avatar.backgroundColor = .lightGray
        userNameLabel.text = "Anonymous"
        view.addSubview(container)
        container.addSubview(avatar)
        container.addSubview(userNameLabel)
        container.addSubview(mainStack)
        container.addSubview(video)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(originalWidthLabel)
        mainStack.addArrangedSubview(originalHeightLabel)
        mainStack.addArrangedSubview(amountFramesLabel)
    }
    
    private func activateConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            container.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            container.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: container.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            avatar.heightAnchor.constraint(equalToConstant: 40),
            avatar.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: avatar.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 5),
            userNameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        video.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            video.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5),
            video.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            video.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            video.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: video.bottomAnchor, constant: 10),
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
    }
    
    func updateUI(withGIF gif: GIF) {
        titleLabel.text = gif.title
        originalWidthLabel.text = "Width: \(gif.images.original.width)"
        originalHeightLabel.text = "Height: \(gif.images.original.height)"
        amountFramesLabel.text = "Frames: \(gif.images.original.frames)"
        guard let user = gif.user else {
            return
        }
        avatar.sd_setImage(with: URL(string: user.avatarURL))
        userNameLabel.text = user.displayName
    }
    
    func playVideo(withUrl url: String) {
        guard let videoURL = URL(string: url) else {
            return
        }
        let playerItem = AVPlayerItem(url: videoURL)
        let player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        let layer = AVPlayerLayer(player: player)
        queuePlayer = player
        playerLayer = layer
        layer.frame = video.bounds
        video.layer.addSublayer(layer)
        player.play()
    }
    
}
