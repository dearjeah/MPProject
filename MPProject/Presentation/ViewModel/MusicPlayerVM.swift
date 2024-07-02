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
    var getSearchData: Observable<[Track]> { get }
    var onReloadTable: Observable<Void> { get }
    func requestData()
//    func getAuth()
    func getSearch(query: String?)
    func refresh()
}

class MusicPlayerVM: ObservableObject, MusicPlayerVMP {
    var viewState: Observable<ViewState> {
        return self.$_viewState.asObservable()
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
        
        self._viewState = self.isResetTime ? .error(error: nil) : .empty
        // self.getToken()
    }
    
    func getAuth() {
        self.repo.getAuth()
            .subscribe {  [weak self] resp in
                let data = resp
                self?.updateLocalStorage(key: .accessToken(data.accessToken))
                self?.updateLocalStorage(key: .resetTime(Date.now.toLocalTime()))
                
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
                
            } onError: { [weak self] err in
                self?._viewState = .error(error: err as? HttpError)
                self?.$onShowError.onNext(err)
            }.disposed(by: disposeBag)
    }
    
    func getSearch(query: String?) {
        if let query = query, query != "", query != " "  {
            self._viewState = .loading
            self.repo.getSearchTrack(query: query)
                .subscribe { [weak self] resp in
                    let data = resp.tracks?.items ?? []
                    self?.searchData = resp.tracks?.items ?? []
                    
                    self?._viewState = data.isEmpty ? .empty : .complete
                } onError: { [weak self] err in
                    self?._viewState = .error(error: err as? HttpError)
                    self?.$onShowError.onNext(err)
                }.disposed(by: disposeBag)
        }
    }
    
    func updateLocalStorage(accessToken: String) {
        self.localStorage.setStorage(key: .accessToken(accessToken))
        self.localStorage.setStorage(key: .resetTime(Date.now.toLocalTime()))
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
    
    func getRemainingResetTime() -> Date? {
        if let saved = resetTime {
            let resetTime = Calendar.current.date(
                byAdding: .minute,
                value: 30,
                to: saved)!
            return resetTime
        }
        return nil
    }
}
