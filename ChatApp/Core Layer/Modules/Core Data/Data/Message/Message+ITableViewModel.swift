//
//  Message+ITableViewModel.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 14/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UITableView

extension Message: ITableViewModel {
  
  var tableViewCell: ITableViewCell { return TableViewCell() }
  
  func cell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    let reusableCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell.reuseIdentifier,
                                                     for: indexPath) as? MessageCell
   
    guard let cell = reusableCell else {
      return UITableViewCell()
    }
    
    cell.updateContent(with: self)
    
    return cell
  }
  
}
