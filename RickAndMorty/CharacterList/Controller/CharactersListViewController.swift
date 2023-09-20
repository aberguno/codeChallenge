//
//  CharactersListViewController.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 16/09/2023.
//

import Combine
import Nuke
import NukeExtensions
import UIKit

class CharactersListViewController: UIViewController {
    private let charactersListTableView = CharactersListTableView()
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorPalette.background
        title = "Wubba lubba dub dub"
        
        //TODO
        //let searchController = UISearchController(searchResultsController: nil)
        //navigationItem.searchController = searchController

        setupViews()
        createBindingViewWithView()
        
        configImageLoading()
    }
}

// MARK: - Setup

private extension CharactersListViewController {
    func setupViews() {
        charactersListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(charactersListTableView)
        NSLayoutConstraint.activate([
            charactersListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            charactersListTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            charactersListTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            charactersListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    func createBindingViewWithView() {
        charactersListTableView.showErrorMessage.sink { [weak self] errorMessage in
            self?.showToast(message: errorMessage, seconds: 4.0, preferredStyle: .actionSheet)
        }.store(in: &cancellables)

        charactersListTableView.didSelectCharacter.sink { [weak self] character in
            let viewModel = CharacterDetailViewViewModel(character: character)
            let detailVC = CharacterDetailViewController(viewModel: viewModel)
            detailVC.navigationItem.largeTitleDisplayMode = .never
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }.store(in: &cancellables)
    }
    
    func configImageLoading() {
        let contentModes = ImageLoadingOptions.ContentModes(
            success: .scaleAspectFit,
            failure: .scaleAspectFit,
            placeholder: .scaleAspectFit)

        ImageLoadingOptions.shared.contentModes = contentModes
        ImageLoadingOptions.shared.transition = .fadeIn(duration: 0.25)
        ImageLoadingOptions.shared.pipeline = ImagePipeline.shared
    }
}
