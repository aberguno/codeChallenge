//
//  CharacterTableViewCell.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 17/09/2023.
//

import Foundation
import Nuke
import NukeExtensions
import UIKit

class CharacterTableViewCell: UITableViewCell {
    private var viewModel: CharacterTableViewCellViewModel?
    
    private let contianerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPalette.characterBackgroundCell
        view.layer.cornerRadius = .kContainerViewCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
//        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
//        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kNameLabelSize, weight: .medium, width: .expanded)
        label.textColor = ColorPalette.tint
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .left
        return label
    }()
    
    private let characterStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kStatusLabelSize, weight: .regular, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = ""
        label.textAlignment = .left
        return label
    }()
            
    // MARK: - Initialization

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        characterImageView.image = nil
        characterNameLabel.text = ""
        characterStatusLabel.text = ""
    }
        
    public func configure(with viewModel: CharacterTableViewCellViewModel) {
        self.viewModel = viewModel
        
        characterNameLabel.text = viewModel.characterName
        characterStatusLabel.attributedText = viewModel.characterStatusAndSpecieText
        
        let request = ImageRequest(url: viewModel.characterImageUrl)
        NukeExtensions.loadImage(with: request, into: characterImageView)
    }
}

// MARK: - Setup

private extension CharacterTableViewCell {
    func setupView() {
        addSubview(contianerView)
        
        [characterImageView, characterNameLabel, characterStatusLabel].forEach(contianerView.addSubview)
        
        NSLayoutConstraint.activate([
            contianerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .kContainerViewPadding),
            contianerView.topAnchor.constraint(equalTo: topAnchor, constant: .kContainerViewPadding),
            contianerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.kContainerViewPadding),
            contianerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.kContainerViewPadding),
            
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: contianerView.topAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contianerView.bottomAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: .kImageSize),

            characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: .kNameHorizontalPadding),
            characterNameLabel.trailingAnchor.constraint(equalTo: contianerView.trailingAnchor, constant: -.kNameHorizontalPadding),
            characterNameLabel.topAnchor.constraint(equalTo: contianerView.topAnchor, constant: .kVerticalPadding),

            characterStatusLabel.leadingAnchor.constraint(equalTo: characterNameLabel.leadingAnchor),
            characterStatusLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: .kVerticalPadding),
        ])
    }
}

