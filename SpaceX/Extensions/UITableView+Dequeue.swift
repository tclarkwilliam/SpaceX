//
//  UITableView+Dequeue.swift
//  SpaceX
//
//  Created by Tom on 19/09/2021.
//

import UIKit

extension UITableView {
  func dequeue<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
    dequeueReusableCell(withIdentifier: String(describing: T.self),
                        for: indexPath) as! T
  }
}
