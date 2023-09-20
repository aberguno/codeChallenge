//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 19/09/2023.
//

import Combine
import Nuke
import NukeExtensions
import UIKit

final class CharacterDetailView: UIView {
    private var viewModel: CharacterDetailViewViewModel
    private var cancellables = Set<AnyCancellable>()

    private let containerView: UIView = {
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
        imageView.layer.cornerRadius = .kContainerViewCornerRadius
        imageView.clipsToBounds = true
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return imageView
    }()

    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kNameLabelSize * 1.5, weight: .medium, width: .expanded)
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
        label.numberOfLines = 0
        label.text = ""
        label.textAlignment = .left
        return label
    }()

    private let characterOriginTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationTitleLabelSize, weight: .medium, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = "Origin"
        label.textAlignment = .left
        return label
    }()

    private let characterOriginTitleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.characterLocationViewFinder, ColorPalette.characterLocationArrow])
        // imageView.image = UIImage(systemName: "location.fill", withConfiguration: config)
        return imageView
    }()

    private let characterOriginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationLabelSize, weight: .regular, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = ""
        label.textAlignment = .left
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .clear

        let button = UIButton(type: .system, primaryAction: UIAction(handler: { [weak self] _ in
            guard let weakSelf = self else { return }
            if weakSelf.viewModel.characterFavorited {
                Favorites.shared.remove(weakSelf.viewModel.characterId)
            } else {
                Favorites.shared.add(weakSelf.viewModel.characterId)
            }
            weakSelf.favoriteButton.addPulseAnimation()
        }))

        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()

    // Location Container

    private let locationcontainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorPalette.characterBackgroundCell
        view.layer.cornerRadius = .kContainerViewCornerRadius
        view.clipsToBounds = true
        return view
    }()

    // Last Known Location

    private let characterLastLocationTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationTitleLabelSize, weight: .medium, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = "Last known location"
        label.textAlignment = .left
        return label
    }()

    private let characterLastLocationTitleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.characterLocationViewFinder, ColorPalette.characterLocationArrow])
        imageView.image = UIImage(systemName: "location.viewfinder", withConfiguration: config)
        return imageView
    }()

    private let characterLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationLabelSize, weight: .regular, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = ""
        label.textAlignment = .left
        return label
    }()

    private var characterLocationLabelConstraint: NSLayoutConstraint?

    // Location Type

    private let characterLocationTypeTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationTitleLabelSize, weight: .medium, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = "Type"
        label.textAlignment = .left
        return label
    }()

    private let characterLocationTypeTitleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.characterLocationViewFinder, ColorPalette.characterLocationArrow])
        imageView.image = UIImage(systemName: "globe.americas", withConfiguration: config)
        return imageView
    }()

    private let characterLocationTypeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationLabelSize, weight: .regular, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = ""
        label.textAlignment = .left
        return label
    }()

    // Location Dimension

    private let characterLocationDimensionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationTitleLabelSize, weight: .medium, width: .expanded)
        label.textColor = ColorPalette.subtitle
        label.numberOfLines = 1
        label.text = "Dimension"
        label.textAlignment = .left
        return label
    }()

    private let characterLocationDimensionTitleIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.characterLocationViewFinder, ColorPalette.characterLocationArrow])
        imageView.image = UIImage(systemName: "tropicalstorm", withConfiguration: config)
        return imageView
    }()

    private let characterLocationDimensionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: .kLocationLabelSize, weight: .regular, width: .expanded)
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

    init(frame: CGRect, viewModel: CharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = ColorPalette.background
        setupViews()
        configureView()
        createBindingViewFavorites()
        viewModel.requestLocation()
    }
}

// MARK: - Setup

private extension CharacterDetailView {
    func setupViews() {
        addSubview(containerView)

        [characterImageView, characterNameLabel, characterStatusLabel, characterOriginTitleLabel, characterOriginTitleIcon, characterOriginLabel, characterLastLocationTitleLabel, characterLastLocationTitleIcon, characterLocationLabel, favoriteButton].forEach(containerView.addSubview)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .kContainerViewPadding),
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: .kContainerViewPadding),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.kContainerViewPadding),
            // containerView.heightAnchor.constraint(equalToConstant: .kContainerDetailViewHeight),

            characterImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            characterImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            characterImageView.heightAnchor.constraint(equalToConstant: .kImageSize),
            characterImageView.widthAnchor.constraint(equalToConstant: .kImageSize),

            characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: .kNameHorizontalPadding),
            characterNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.kNameHorizontalPadding),
            characterNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .kVerticalPadding),

            characterStatusLabel.leadingAnchor.constraint(equalTo: characterNameLabel.leadingAnchor),
            characterStatusLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: .kVerticalPadding),

            characterOriginTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .kHorizontalPadding),
            characterOriginTitleLabel.topAnchor.constraint(equalTo: characterImageView.bottomAnchor, constant: .kVerticalPadding * 2),

            characterOriginTitleIcon.leadingAnchor.constraint(equalTo: characterOriginTitleLabel.trailingAnchor, constant: .kHorizontalPadding),
            characterOriginTitleIcon.centerYAnchor.constraint(equalTo: characterOriginTitleLabel.centerYAnchor),

            characterOriginLabel.leadingAnchor.constraint(equalTo: characterOriginTitleLabel.leadingAnchor, constant: .kHorizontalPadding),
            characterOriginLabel.topAnchor.constraint(equalTo: characterOriginTitleLabel.bottomAnchor, constant: .kVerticalPadding),
            characterOriginLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.kVerticalPadding * 2),

            favoriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.kHorizontalPadding),
            favoriteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.kHorizontalPadding),
        ])

        // Location
        addSubview(locationcontainerView)

        [characterLastLocationTitleLabel, characterLastLocationTitleIcon, characterLocationLabel, characterLocationTypeTitleLabel, characterLocationTypeTitleIcon, characterLocationTypeLabel, characterLocationDimensionTitleLabel, characterLocationDimensionTitleIcon, characterLocationDimensionLabel].forEach(locationcontainerView.addSubview)

        NSLayoutConstraint.activate([
            locationcontainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            locationcontainerView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .kContainerViewPadding),
            locationcontainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // Last Known Location
            characterLastLocationTitleLabel.leadingAnchor.constraint(equalTo: locationcontainerView.leadingAnchor, constant: .kHorizontalPadding),
            characterLastLocationTitleLabel.topAnchor.constraint(equalTo: locationcontainerView.topAnchor, constant: .kVerticalPadding * 2),

            characterLastLocationTitleIcon.leadingAnchor.constraint(equalTo: characterLastLocationTitleLabel.trailingAnchor, constant: .kHorizontalPadding),
            characterLastLocationTitleIcon.centerYAnchor.constraint(equalTo: characterLastLocationTitleLabel.centerYAnchor),

            characterLocationLabel.leadingAnchor.constraint(equalTo: characterLastLocationTitleLabel.leadingAnchor, constant: .kHorizontalPadding),
            characterLocationLabel.topAnchor.constraint(equalTo: characterLastLocationTitleLabel.bottomAnchor, constant: .kVerticalPadding),

            // Location Type
            characterLocationTypeTitleLabel.leadingAnchor.constraint(equalTo: locationcontainerView.leadingAnchor, constant: .kHorizontalPadding),
            characterLocationTypeTitleLabel.topAnchor.constraint(equalTo: characterLocationLabel.bottomAnchor, constant: .kVerticalPadding * 2),

            characterLocationTypeTitleIcon.leadingAnchor.constraint(equalTo: characterLocationTypeTitleLabel.trailingAnchor, constant: .kHorizontalPadding),
            characterLocationTypeTitleIcon.centerYAnchor.constraint(equalTo: characterLocationTypeTitleLabel.centerYAnchor),

            characterLocationTypeLabel.leadingAnchor.constraint(equalTo: characterLocationTypeTitleLabel.leadingAnchor, constant: .kHorizontalPadding),
            characterLocationTypeLabel.topAnchor.constraint(equalTo: characterLocationTypeTitleLabel.bottomAnchor, constant: .kVerticalPadding),

            // Location Dimension
            characterLocationDimensionTitleLabel.leadingAnchor.constraint(equalTo: locationcontainerView.leadingAnchor, constant: .kHorizontalPadding),
            characterLocationDimensionTitleLabel.topAnchor.constraint(equalTo: characterLocationTypeLabel.bottomAnchor, constant: .kVerticalPadding * 2),

            characterLocationDimensionTitleIcon.leadingAnchor.constraint(equalTo: characterLocationDimensionTitleLabel.trailingAnchor, constant: .kHorizontalPadding),
            characterLocationDimensionTitleIcon.centerYAnchor.constraint(equalTo: characterLocationDimensionTitleLabel.centerYAnchor),

            characterLocationDimensionLabel.leadingAnchor.constraint(equalTo: characterLocationDimensionTitleLabel.leadingAnchor, constant: .kHorizontalPadding),
            characterLocationDimensionLabel.topAnchor.constraint(equalTo: characterLocationDimensionTitleLabel.bottomAnchor, constant: .kVerticalPadding),
        ])

        characterLocationLabelConstraint = characterLocationLabel.bottomAnchor.constraint(equalTo: locationcontainerView.bottomAnchor, constant: -.kVerticalPadding * 2)
        characterLocationLabelConstraint?.priority = .defaultHigh
        
        let characterLocationDimensionLabelConstraint = characterLocationDimensionLabel.bottomAnchor.constraint(equalTo: locationcontainerView.bottomAnchor, constant: -.kVerticalPadding * 2)
        characterLocationDimensionLabelConstraint.priority = .defaultLow
        characterLocationDimensionLabelConstraint.isActive = true
    }

    func configureView() {
        characterNameLabel.text = viewModel.characterName
        characterStatusLabel.attributedText = viewModel.characterStatusAndSpecieText

        characterOriginLabel.text = viewModel.characterOriginName
        characterOriginTitleIcon.image = viewModel.imageForOrigin

        characterLocationLabel.text = viewModel.characterLocationName
        animateLocationImage(true)

        let request = ImageRequest(url: viewModel.characterImageUrl)
        NukeExtensions.loadImage(with: request, into: characterImageView)

        // Hide location type/dimension if last known location is unknown
        if viewModel.isCharacterLocationUnknown {
            characterLocationTypeTitleLabel.isHidden = true
            characterLocationTypeTitleIcon.isHidden = true
            characterLocationTypeLabel.isHidden = true
            characterLocationDimensionTitleLabel.isHidden = true
            characterLocationDimensionTitleIcon.isHidden = true
            characterLocationDimensionLabel.isHidden = true
            characterLocationLabelConstraint?.isActive = true
        }
    }
}

private extension CharacterDetailView {
    func animateLocationImage(_ value: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1000)) { [weak self] in
            self?.characterLastLocationTitleIcon.addPulseAnimation(repeatCount: 2)
        }
    }

    func createBindingViewFavorites() {
        viewModel.$characterFavorited.sink { [weak self] characterFavorited in
            let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.favoriteHeart])
            self?.favoriteButton.setImage(UIImage(systemName: characterFavorited ? "heart.fill" : "heart", withConfiguration: config), for: .normal)
        }.store(in: &cancellables)

        // Config Location extra data
        viewModel.$locationDetailType
            .assign(to: \.text!, on: characterLocationTypeLabel)
            .store(in: &cancellables)

        viewModel.$locationDetailDimension
            .assign(to: \.text!, on: characterLocationDimensionLabel)
            .store(in: &cancellables)
    }
}
