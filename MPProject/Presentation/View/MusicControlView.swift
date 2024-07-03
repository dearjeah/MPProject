//
//  MusicControlView.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import UIKit
import SnapKit
import Lottie

enum PlayerControl {
    case play
    case pause
    case stop
}

protocol MusicControlViewDelegate: AnyObject {
    func didMidButtonChange(_ control: PlayerControl)
}

class MusicControlView: UIView {
    var control: PlayerControl = .stop
    
    weak var delegate: MusicControlViewDelegate?
    
    private lazy var previousButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "backward.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    private lazy var playPauseButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "stop.circle.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    private lazy var nextButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "forward.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.setupConstraint()
        self.setupEvent()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubviews(
            previousButton,
            playPauseButton,
            nextButton
        )
        self.backgroundColor = .baseWhite
    }
    
    private func setupConstraint() {
        self.snp.makeConstraints {
            $0.height.equalTo(65)
        }
        previousButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(32)
            $0.size.equalTo(30)
        }
        playPauseButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(30)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(32)
            $0.size.equalTo(30)
        }
    }
    
    private func setupEvent() {
        playPauseButton.onClick = { [weak self] in
            guard let self = self else { return }
            
            switch self.control {
            case .play:
                delegate?.didMidButtonChange(.pause)
            case .pause:
                delegate?.didMidButtonChange(.play)
            case .stop:
                delegate?.didMidButtonChange(.stop)
            }
        }
    }
    
    func midButtonAction(_ control: PlayerControl) {
        self.control = control
        playPauseButton.image = nil
        
        switch control {
        case .play:
            playPauseButton.image = UIImage(systemName: "pause.circle.fill")
        case .pause:
            playPauseButton.image = UIImage(systemName: "play.circle.fill")
        case .stop:
            playPauseButton.image = UIImage(systemName: "stop.circle.fill")
        }
    }
}
