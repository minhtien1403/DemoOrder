//
//  UITableVIew+.swift
//  DemoFabbi
//
//  Created by tientm on 04/02/2024.
//

import UIKit

extension UITableView {
    
    func registerCell(_ cellType: UITableViewCell.Type) {
        self.register(UINib(nibName: "\(cellType.self)", bundle: nil), forCellReuseIdentifier: "\(cellType.self)")
    }

    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: "\(T.self)", for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.self)")
        }
        return cell
    }
}
