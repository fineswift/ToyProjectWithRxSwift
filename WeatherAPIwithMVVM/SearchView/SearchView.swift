//
//  SearchView.swift
//  WeatherAPIwithMVVM
//
//  Created by 허광호 on 2020/09/18.
//

import UIKit

class SearchView: UIView, UIBasePreView {
    // MARK: - Model type implemente
    typealias Model = Void

    let disposeBag = DisposeBag()

    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        searchBar.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Objects
    let tableView = UITableView()
    let searchBar = UISearchBar().then {
        $0.placeholder = "location name"
        $0.sizeToFit()
        $0.returnKeyType = .done
    }

    // MARK: - Methods
    func setupLayout() {
        self.addSubview(tableView)
        self.backgroundColor = .systemBackground

        tableView.tableHeaderView = searchBar
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - model Dependency Injection
    /// 서버에서 받아온 도시 정보
    func setupDI<T>(observable: Observable<T>) -> Self {
        if let cityList = observable as? Observable<[List]> {
            cityList.bind(to: tableView.rx.items(cellIdentifier: "Cell")) { row, element, cell in
                cell.textLabel?.text = element.name
            }.disposed(by: disposeBag)
        } else {
            NSLog("Observable Type Error!!!(미구현): SearchView")
        }
        return self
    }

    /// 터치 액션
    @discardableResult
    func setupDI<T>(generic: PublishRelay<T>) -> Self {
        if let search = generic as? PublishRelay<SearchInput> {
            searchBar.rx.text
                .orEmpty
                .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .map { .searchText($0) }
                .bind(to: search)
                .disposed(by: disposeBag)

            tableView.rx.modelSelected(List.self)
                .map { .modelSelect($0) }
                .bind(to: search)
                .disposed(by: disposeBag)

            tableView.rx.itemSelected
                .bind(onNext: { [weak self] index in
                    guard let `self` = self else { return }
                    let cell = self.tableView.cellForRow(at: index)
                    cell?.isSelected = false
                }).disposed(by: disposeBag)
        } else {
            NSLog("PublishRelay Type Error!!!(미구현): SearchView")
        }
        return self
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
}
