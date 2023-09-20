//
//  ModalAlert.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 18/09/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message: String, seconds: Double, preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: preferredStyle)
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
}
