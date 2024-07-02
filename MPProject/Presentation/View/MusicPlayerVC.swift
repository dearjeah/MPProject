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
    
    private lazy var selectedMusic: IndexPath? = nil
    
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
        table.allowsMultipleSelection = false
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
        
        self.viewModel.viewState.subscribe(
            onNext: { [weak self] viewState in
                guard let self = self else { return }
//                HttpError.
                switch viewState {
                case .error(let err):
                    if err?.errorBody?.status == 503 || err?.errorBody?.status == 0 {
                        self.showAlert(type: .error, 
                                       withMessage: err?.errorBody?.description ?? "Error Occured")
                    } else {
                        self.accessCodePrompt()
                    }
                default:
                    return
                }
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
            return self.viewModel.localTrackData.count
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
        let cell: MusicDetailCell = tableView.cellForRow(at: indexPath) as! MusicDetailCell
        
        if indexPath.section == 0 {
            self.showAlert(
                type: .info,
                withMessage: "This API currently is not available to playback the music." )
        } else {
            let track = self.viewModel.localTrackData[indexPath.row]
            self.playMusic(uri: track.uri)
            self.selectedMusic = indexPath
            cell.isMusicPlay = true
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell: MusicDetailCell = tableView.cellForRow(at: indexPath) as! MusicDetailCell
        self.selectedMusic = nil
        cell.isMusicPlay = false
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
            title = "We were sorry"
        }
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert,
                     animated: true)
    }
    
    private func accessCodePrompt() {
        let ac = UIAlertController(
            title: "Access Token Required",
            message: """
            Since there is a problem with the API implementation,
            add the access token manually. Please refer to the developer.
            After you add the access token, please try to search the tracks. Thank you.
        """,
            preferredStyle: .alert)
        ac.addTextField{ [weak self] (textField) in
            guard self != nil else { return }
            textField.placeholder = "Input Access Code Here"
            textField.isSecureTextEntry = true
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text
            if answer == "" || answer == " " {
                self.showAlert(type: .error, withMessage: "Do it properly")
                self.accessCodePrompt()
            } else {
                self.viewModel.updateLocalStorage(accessToken: answer ?? "")
            }
        }

        ac.addAction(submitAction)

        DispatchQueue.main.async {
            self.present(ac, animated: true, completion: nil)
        }
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
        self.updateMusicCell(control)
        
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
    
    func updateMusicCell(_ control: PlayerControl) {
        if let indexPath = selectedMusic {
            let cell: MusicDetailCell = tableView.cellForRow(at: indexPath) as! MusicDetailCell
            
            if indexPath.section == 1 {
                switch control {
                case .play:
                    cell.isMusicPlay = true
                default:
                    cell.isMusicPlay = false
                }
            }
        }
    }
}
