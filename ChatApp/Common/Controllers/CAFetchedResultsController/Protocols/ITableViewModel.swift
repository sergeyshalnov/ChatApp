//
//  ITableViewModel.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UITableView

protocol ITableViewModel {
  
  var tableViewCell: ITableViewCell { get }
  
  func cell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell
  
}
