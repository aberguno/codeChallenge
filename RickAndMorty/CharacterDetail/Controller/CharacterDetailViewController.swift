//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 19/09/2023.
//

import Foundation
import UIKit

final class CharacterDetailViewController: UIViewController {
    private var characterDetailView: CharacterDetailView

    init(viewModel: CharacterDetailViewViewModel) {
        self.characterDetailView = CharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.backButton])
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward", withConfiguration: config), style: .plain, target: self, action: #selector(back(sender:)))
    }
    
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = ColorPalette.background
        setupViews()
    }
}

// MARK: - Setup

private extension CharacterDetailViewController {
    func setupViews() {
        characterDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(characterDetailView)
        NSLayoutConstraint.activate([
            characterDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterDetailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterDetailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
