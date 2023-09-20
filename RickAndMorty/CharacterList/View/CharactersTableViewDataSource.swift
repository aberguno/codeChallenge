//
//  CharactersTableViewDataSource.swift
//  RickAndMorty
//
//  Created by Ariel Berguño on 17/09/2023.
//

import Foundation
import UIKit

final class CharactersTableViewDataSource: NSObject, UITableViewDataSource {
    var endRowReachedHandler: (() -> Void)?
    
    private let tableView: UITableView
    
    private(set) var cellViewModels: [CharacterTableViewCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    init(tableView: UITableView, cellViewModels: [CharacterTableViewCellViewModel] = []) {
        self.tableView = tableView
        self.cellViewModels = cellViewModels
    }
    
    func set(cellViewModels: [CharacterTableViewCellViewModel]) {
        self.cellViewModels = cellViewModels
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterTableViewCell", for: indexPath) as! CharacterTableViewCell
        
        if indexPath.row == cellViewModels.count - 1 {
            endRowReachedHandler?()
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        
        return cell
    }
}
