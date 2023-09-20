//
//  Utils.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 19/09/2023.
//

import Foundation
import UIKit

final class Utils {
    static func formatStatusSpecieLabel(status: String, species: String ) -> NSMutableAttributedString {
        let statusImageAttachment = NSTextAttachment()
        statusImageAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 12)
        if status.lowercased() == "alive" {
            statusImageAttachment.image = UIImage(systemName: "heart.fill")?.withTintColor(ColorPalette.characterStatusAlive)
        } else if status.lowercased() == "dead" {
            statusImageAttachment.image = UIImage(systemName: "heart.slash.fill")?.withTintColor(ColorPalette.characterStatusDead)
        } else {
            statusImageAttachment.image = UIImage(systemName: "heart.slash")?.withTintColor(ColorPalette.characterStatusUnknown)
        }

        let speciesImageAttachment = NSTextAttachment()
        speciesImageAttachment.bounds = CGRect(x: 0, y: -2, width: 16, height: 12)
        if species.lowercased() == "human" {
            speciesImageAttachment.image = UIImage(systemName: "person.fill.checkmark")?.withTintColor(ColorPalette.characterStatusUnknown)
        } else if species.lowercased() == "alien" {
            speciesImageAttachment.image = UIImage(systemName: "person.fill.xmark")?.withTintColor(ColorPalette.characterStatusUnknown)
        } else {
            speciesImageAttachment.image = UIImage(systemName: "person.fill.questionmark")?.withTintColor(ColorPalette.characterStatusUnknown)
        }
        
        let fullString = NSMutableAttributedString(attachment: statusImageAttachment)
        fullString.append(NSAttributedString(string: " \(status.capitalized)"))
        fullString.append(NSAttributedString(string: "- \(species.capitalized) "))
        fullString.append(NSAttributedString(attachment: speciesImageAttachment))
        return fullString
    }
    
    static func imageForOrigin(characterOriginIsUnknown: Bool) -> UIImage? {
        if characterOriginIsUnknown {
            let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.characterOriginArrowUnknown])
            return UIImage(systemName: "location.slash", withConfiguration: config)
        } else {
            let config = UIImage.SymbolConfiguration(paletteColors: [ColorPalette.characterOriginArrow])
            return UIImage(systemName: "location", withConfiguration: config)
        }
    }
}
