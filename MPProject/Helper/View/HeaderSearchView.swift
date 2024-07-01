//
//  HeaderSearchView.swift
//  MPProject
//
//  Created by Delvina Janice on 01/07/24.
//

import UIKit
import RxSwift

protocol HeaderSearchDelegate: AnyObject {
    func didSearch(searchText: String?)
}

final class HeaderSearchView: UIView {
    weak var delegate: HeaderSearchDelegate?
    var searchPlaceHolder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: searchPlaceHolder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
            )
        }
    }

    // MARK: - UI
    private lazy var searchBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_search_discovery") ?? UIImage(), for: .normal)
        button.snp.makeConstraints {
            $0.height.width.equalTo(20)
        }
        return button
    }()

    private lazy var containerSearch: UIView = {
        let view = UIView()
        view.addBorder(thickness: 1, withColor: .gray, radius: 4)
        return view
    }()

    private lazy var textField: UITextField = {
        let textfield = UITextField()
        textfield.frame = .zero
        textfield.font = .systemFont(ofSize: 14)
        textfield.backgroundColor = .clear
        textfield.textColor = .black
        return textfield
    }()

    private let disposeBag = DisposeBag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraint()
        setupEvent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.backgroundColor = .baseWhite
        
        addSubviews(
            containerSearch
        )
        containerSearch.addSubviews(
            searchBtn,
            textField
        )
    }

    func setupConstraint() {
        snp.makeConstraints { $0.height.equalTo(65) }
        containerSearch.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.equalToSuperview().offset(16)
        }
        searchBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.centerY.equalToSuperview()
        }
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(searchBtn.snp.leading).offset(-16)
        }
    }

    func setupEvent() {
        textField.rx.controlEvent(.editingDidBegin).bind { [weak self] in
            self?.enableSearch(true)
        }.disposed(by: disposeBag)

        textField.rx.controlEvent(.editingChanged)
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.enableSearch(!(self?.textField.text?.isEmpty ?? false))
                self?.delegate?.didSearch(searchText: self?.textField.text)
            }
            .disposed(by: disposeBag)

        searchBtn.rx.tap.bind { [weak self] in
            self?.textField.text = ""
            self?.textField.resignFirstResponder()
            self?.delegate?.didSearch(searchText: self?.textField.text)
            self?.enableSearch(false)
        }.disposed(by: disposeBag)
    }

    private func enableSearch(_ enable: Bool) {
        let icClose =  UIImage(systemName: "xmark")?
            .withTintColor(.black)
        let icSearch =  UIImage(systemName: "magnifyingglass")?
            .withTintColor(.black)
        searchBtn.isUserInteractionEnabled = enable
        searchBtn.setImage(enable ? icClose : icSearch, for: .normal)
    }
    public func enableBorderChange(_ enable: Bool) {
        if enable {
            containerSearch.layer.borderColor = UIColor.black.cgColor
        } else {
            containerSearch.layer.borderColor = UIColor.gray.cgColor
        }
    }
}
