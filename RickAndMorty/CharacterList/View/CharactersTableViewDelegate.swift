//
//  CharactersTableViewDelegate.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 18/09/2023.
//

import Combine
import Foundation
import UIKit

final class CharactersTableViewDelegate: NSObject, UITableViewDelegate {
    var didTapOnCell: ((Int) -> Void)?

    private let tableView: UITableView
    private(set) var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()

    private(set) var cellViewModels: [CharacterTableViewCellViewModel] = [] {
        didSet {
//            DispatchQueue.main.async { [weak self] in
//                self?.tableView.reloadData()
//            }
        }
    }

    init(tableView: UITableView, isLoading: Bool = false, cellViewModels: [CharacterTableViewCellViewModel] = []) {
        self.tableView = tableView
        self.isLoading = isLoading
        self.cellViewModels = cellViewModels
    }

    func set(isLoading: Bool) {
        self.isLoading = isLoading
    }

    func set(cellViewModels: [CharacterTableViewCellViewModel]) {
        self.cellViewModels = cellViewModels
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .kContainerCellViewHeight
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard isLoading else {
            tableView.tableFooterView = nil
            return
        }

        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let uploadedAction = UIContextualAction(style: .normal, title: "", handler: { [weak self]
            _, _, completionHandler in
                guard let weakSelf = self else {
                    completionHandler(false)
                    return
                }

                if weakSelf.cellViewModels[indexPath.row].characterFavorited {
                    Favorites.shared.remove(weakSelf.cellViewModels[indexPath.row].characterId)
                } else {
                    Favorites.shared.add(weakSelf.cellViewModels[indexPath.row].characterId)
                }

                completionHandler(true)
        })
        uploadedAction.backgroundColor = ColorPalette.favoriteCellActionBackground
        let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.favoriteHeart])
        uploadedAction.image = UIImage(systemName: cellViewModels[indexPath.row].characterFavorited ? "heart.fill" : "heart", withConfiguration: config)

        let swipeConfiguration = UISwipeActionsConfiguration(actions: [uploadedAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didTapOnCell?(indexPath.row)
    }
}
