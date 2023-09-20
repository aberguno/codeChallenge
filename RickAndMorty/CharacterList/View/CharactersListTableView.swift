//
//  CharactersListTableView.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 17/09/2023.
//

import Combine
import Foundation
import UIKit

class CharactersListTableView: UIView {
    let showErrorMessage = PassthroughSubject<String, Never>()
    let didSelectCharacter = PassthroughSubject<CharacterModel, Never>()

    private var tableViewDataSource: CharactersTableViewDataSource?
    private var tableViewDelegate: CharactersTableViewDelegate?

    private let viewModel = CharactersListTableViewViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = ColorPalette.background
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterTableViewCell")
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ColorPalette.background

        setupViews()
        configTableView()

        // Data related
        createBindingViewWithViewModel()
        requestCharacters()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        tableView.separatorStyle = .none
    }
}

// MARK: - Setup

private extension CharactersListTableView {
    func setupViews() {
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
        ])
    }

    func configTableView() {
        // Define TableView Delegate
        tableViewDelegate = CharactersTableViewDelegate(tableView: tableView)
        tableViewDelegate?.didTapOnCell = { [weak self] index in
            guard let character = self?.viewModel.characters[index] else { return }
            self?.didSelectCharacter.send(character)
        }
        tableView.delegate = tableViewDelegate

        // Define TableView DataSource
        tableViewDataSource = CharactersTableViewDataSource(tableView: tableView)
        tableViewDataSource?.endRowReachedHandler = { [weak self] in
            self?.requestCharacters()
        }
        tableView.dataSource = tableViewDataSource
    }
}

private extension CharactersListTableView {
    func requestCharacters() {
        viewModel.requestNextCharacters()
    }

    func createBindingViewWithViewModel() {
        viewModel.$isLoading.sink { [weak self] isLoading in
            self?.tableViewDelegate?.set(isLoading: isLoading)
        }.store(in: &cancellables)

        viewModel.$errorMessage.sink { [weak self] errorMessage in
            guard let errorMessage = errorMessage else { return }
            self?.showErrorMessage.send(errorMessage)
        }.store(in: &cancellables)

        viewModel.$cellViewModels.sink { [weak self] cellViewModels in
            self?.tableViewDelegate?.set(cellViewModels: cellViewModels)
            self?.tableViewDataSource?.set(cellViewModels: cellViewModels)
        }.store(in: &cancellables)
    }
}
