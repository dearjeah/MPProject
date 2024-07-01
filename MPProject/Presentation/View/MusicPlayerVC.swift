//
//  MusicPlayerVC.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import UIKit
import UIKit
import SnapKit
import RxSwift
import AVFoundation

class MusicPlayerVC: UIViewController {
    private let disposeBag = DisposeBag()
    lazy var viewModel = MusicPlayerVM(repo: MusicPlayerDefaultRepo())
    
    private enum AlertType {
        case error
        case info
    }
    
    private var player: AVAudioPlayer = AVAudioPlayer()
    
    private lazy var searchHeader = HeaderSearchView()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .singleLine
        table.tableHeaderView = nil
        table.tableFooterView = nil
        table.sectionHeaderTopPadding = 0
        table.sectionHeaderHeight = 0
        table.sectionFooterHeight = 0
        table.sizeToFit()
        table.registerCells(MusicDetailCell.self)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var musicControlView: MusicControlView = {
        let controlView = MusicControlView()
        controlView.delegate = self
        return controlView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraint()
        setupEvent()
    }
    
    func setupUI() {
        self.view.backgroundColor = .baseWhite
        self.view.addSubviews(
            searchHeader,
            tableView,
            musicControlView
        )
        searchHeader.delegate = self
        self.player.delegate = self
        
    }
    
    func setupConstraint() {
        searchHeader.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchHeader.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        musicControlView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupEvent() {
        self.viewModel.requestData()
        self.viewModel.getSearchData.subscribe(
            onNext: { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}

extension MusicPlayerVC: HeaderSearchDelegate {
    func didSearch(searchText: String?) {
        self.viewModel.getSearch(query: searchText)
    }
}

extension MusicPlayerVC: UITableViewDataSource ,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.searchData.count
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MusicDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if indexPath.section == 0 {
            let track = self.viewModel.searchData[indexPath.row]
            cell.setupData(imgUrl: track.album?.images?[0].url,
                           title: track.name,
                           artist: track.artists?[0].name,
                           album: track.album?.name)
            return cell
            
        } else {
            let track = self.viewModel.localTrackData[indexPath.row]
            cell.setupData(imgUrl: nil,
                           title: track.name,
                           artist: track.artists?[0].name,
                           album: track.album?.name)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.showAlert(type: .info, withMessage: "this is \(indexPath.row) row")
        } else {
            let track = self.viewModel.localTrackData[indexPath.row]
            self.playMusic(uri: track.uri)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return self.viewModel.searchData.count == 0 ? 0 : 30
        } else {
            return 30
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return self.viewModel.searchData.count == 0 ? nil : "Spotify Result"
        } else {
            return "Local Music"
        }
    }
}

extension MusicPlayerVC {
    private func showAlert(type: AlertType, withMessage message: String) {
        var title: String = ""
        switch type {
        case .error:
            title = "Error"
        case .info:
            title = "For Your Information"
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        self.present(alert,
                     animated: true)
    }
}

// MARK: AVFoundation config
extension MusicPlayerVC: AVAudioPlayerDelegate, MusicControlViewDelegate {
    // delegate Music Control View
    func didMidButtonChange(_ control: PlayerControl) {
        self.playerControl(control)
    }
    
    func playMusic(uri: String?) {
        // set up player
        if let uri = uri {
            let urlString = Bundle.main.path(forResource: uri, ofType: "mp3")
            
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                guard let urlString = urlString else {
                    print("urlstring is nil")
                    return
                }
                
                player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
                self.playerControl(.play)
            }
            catch {
                print("error occurred")
            }
        }
    }
    
    func playerControl(_ control: PlayerControl) {
        self.musicControlView.midButtonAction(control)
        player.volume = 0.5
        
        switch control {
        case .play:
            player.play()
        case .pause:
            player.pause()
        case .stop:
            player.stop()
        }
    }
}
