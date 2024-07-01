//
//  MusicPlayerVM.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import Foundation
import RxSwift
import RxCocoa
import AVFoundation

protocol MusicPlayerVMP {
    var viewState: Observable<ViewState> { get }
    var getTracksData: Observable<[Track]> { get }
    var getSearchData: Observable<[Track]> { get }
    var onReloadTable: Observable<Void> { get }
//    var onSelectedCell: Observable<RdnHistoryDetail?> { get }
    func requestData()
    func getAuth()
    func getTracks()
    func getSearch(query: String?)
    func refresh()
}

class MusicPlayerVM: ObservableObject, MusicPlayerVMP {
    var viewState: Observable<ViewState> {
        return self.$_viewState.asObservable()
    }
    var getTracksData: Observable<[Track]> {
        return self.$tracksData.asObservable()
    }
    var getSearchData: Observable<[Track]> {
        return self.$searchData.asObservable()
    }
    var getLocalTrack: Observable<[Track]> {
        return self.$localTrackData.asObservable()
    }
    
    private var disposeBag = DisposeBag()
    private let repo: MusicPlayerRepo
    private let localStorage = LocalStorageDefault.shared
    var timer: Timer?
    
    @RxBehavior private(set) var _viewState: ViewState = .loading
    @RxPublished var tracksData: [Track] = []
    @RxPublished var searchData: [Track] = []
    @RxPublished var localTrackData: [Track] = []
    @RxSignal private(set) var onShowError: Observable<Error?>
    @RxSignal private(set) var onReloadTable: Observable<Void>
    
    // MARK: Local Storage
    var resetTime: Date? {
        return localStorage
            .getStorage(key: .resetTime(nil)) as? Date
    }
    
    func updateLocalStorage(key: LocalStorageKey) {
        localStorage.setStorage(key: key)
    }
    
    init(repo: MusicPlayerRepo = MusicPlayerDefaultRepo()) {
        self.repo = repo
    }
    
    
    // MARK: Request Data
    
    func refresh() {
        disposeBag = DisposeBag()
        self.requestData()
    }
    
    func requestData() {
        self._viewState = .loading
        self.localTrackData = TracksSearchModel.localSong.tracks?.items ?? []
        
        self.getToken()
    }
    
    func getAuth() {
        self.repo.getAuth()
            .subscribe {  [weak self] resp in
                let data = resp
                self?.updateLocalStorage(key: .accessToken(data.accessToken))
                self?.updateLocalStorage(key: .resetTime(Date.now.toLocalTime()))
                
                self?.getTracks()
            } onError: { [weak self] err in
                self?._viewState = .error(error: err as? HttpError)
                self?.$onShowError.onNext(err)
            }.disposed(by: disposeBag)
    }
    
    func getToken() {
        self.repo.getToken()
            .subscribe {  [weak self] resp in
                let data = resp
                self?.updateLocalStorage(key: .accessToken(data.accessToken))
                self?.updateLocalStorage(key: .resetTime(Date.now.toLocalTime()))
                
                self?.getTracks()
            } onError: { [weak self] err in
                self?._viewState = .error(error: err as? HttpError)
                self?.$onShowError.onNext(err)
            }.disposed(by: disposeBag)
    }
    
    func getTracks() {
        self.repo.getTrackList()
            .subscribe { [weak self] resp in
                let data = resp
                self?.tracksData = resp.tracks ?? []
            } onError: { [weak self] err in
                self?._viewState = .error(error: err as? HttpError)
                self?.$onShowError.onNext(err)
            }.disposed(by: disposeBag)
    }
    
    func getSearch(query: String?) {
        if let query = query, query != "", query != " "  {
            self.repo.getSearchTrack(query: query)
                .subscribe { [weak self] resp in
                    self?.searchData = resp.tracks?.items ?? []
                } onError: { [weak self] err in
                    self?._viewState = .error(error: err as? HttpError)
                    print("===error search====", err)
                    self?.$onShowError.onNext(err)
                }.disposed(by: disposeBag)
        }
    }
}

// MARK: - Timer
extension MusicPlayerVM {
    var isResetTime: Bool {
        if let resetTime = getRemainingResetTime() {
            return Date.now.toLocalTime() >= resetTime
        } else {
            return true
        }
    }
    
    func checkTimerInterval() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        
        let current = Date.now.toLocalTime()
        let remainingTime = self.getRemainingResetTime() ?? Date.now.toLocalTime()
        
        let difference = formatter.string(from: current, to: remainingTime)?.toDouble ?? 0
        
        self.setInterval(difference * 60.0)
    }
    
    func getRemainingResetTime() -> Date? {
        if let saved = resetTime {
            let resetTime = Calendar.current.date(
                byAdding: .minute,
                value: 60,
                to: saved)!
            return resetTime
        }
        return nil
    }
    
    private func setInterval(_ interval: Double) {
        if interval == -1 || interval == 0 {
            stopTimer()
        } else if interval != 0 {
            switch self._viewState {
            case .error:
                self.startTimer(withInterval: interval) { [weak self] _ in
                    self?.requestData()
                }
            default:
                break
            }
        }
    }
    
    private func startTimer(
        withInterval interval: Double,
        block: @escaping (Timer
        ) -> Void) {
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(
            withTimeInterval: interval,
            repeats: true,
            block: block
        )
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
}
