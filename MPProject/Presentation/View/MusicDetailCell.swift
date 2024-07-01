//
//  MusicDetailCell.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import UIKit
import SnapKit
import Kingfisher
import Lottie

class MusicDetailCell: UITableViewCell {
    private lazy var musicAnimView = UIView()
    private lazy var musicAnimation: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.contentMode = .scaleAspectFit
        return animation
    }()
    
    private lazy var songImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "No-Image-Placeholder")
        image.contentMode = .scaleAspectFit
        image.addBorder(thickness: 1, withColor: .clear, radius: 8)
        return image
    }()

    private lazy var songTitle: UILabel = {
        let label = UILabel()
        label.textColor = .uktPrimary
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var songArtist: UILabel = {
        let label = UILabel()
        label.textColor = .uktSecondary
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    private lazy var songAlbum: UILabel = {
        let label = UILabel()
        label.textColor = .uktPrimary
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
        setupConstraint()
        setContainer()
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupData(imgUrl: String?,
                   title: String?,
                   artist: String?,
                   album: String?) {
        if let url = URL(string: imgUrl ?? "") {
            songImage.kf.setImage(with: url)
        } else {
            songImage.image = UIImage(named: "No-Image-Placeholder")
        }
        songTitle.text = title ?? "No Title"
        songArtist.text = artist ?? "No Artist"
        songAlbum.text = album ?? "No Album"
    }

    private func setupUI() {
        self.contentView.addSubviews(
            songImage,
            songTitle,
            songArtist,
            songAlbum,
            musicAnimView
        )
    }

    private func setupConstraint() {
        songImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.size.equalTo(80)
        }
        songTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.equalTo(songImage.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
        }
        songArtist.snp.makeConstraints {
            $0.top.equalTo(songTitle.snp.bottom).offset(4)
            $0.leading.equalTo(songImage.snp.trailing).offset(8)
            $0.trailing.equalTo(musicAnimView.snp.leading).inset(4)
            $0.centerY.equalToSuperview()
        }
        songAlbum.snp.makeConstraints {
            $0.top.equalTo(songArtist.snp.bottom).offset(4)
            $0.leading.equalTo(songImage.snp.trailing).offset(8)
            $0.trailing.bottom
                .equalToSuperview().inset(8)
        }
        musicAnimView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(40)
            $0.height.equalTo(20)
        }
    }
    
    func setContainer() {
        self.contentView.frame = CGRect(x: 0, y: 0, width: 104, height: 100)
    }
}

extension MusicDetailCell {
    func setupAnimation() {
        let animation = LottieAnimation.named("music_animation.json")

        musicAnimation.animation = animation
        musicAnimation.contentMode = .scaleAspectFill
        musicAnimView.addSubview(musicAnimation)
        musicAnimation.snp.makeConstraints {
            $0.edges.equalTo(musicAnimView)
        }
    }
    
    func playAnimation() {
        musicAnimation.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.loop)
        musicAnimation.backgroundBehavior = .pauseAndRestore
    }
    
    func stopAnimation() {
        musicAnimation.stop()
    }
}
