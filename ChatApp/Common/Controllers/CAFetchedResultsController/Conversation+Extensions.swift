//
//  Conversation+Extensions.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 09/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UITableView

extension Conversation: ITableViewModel {
  
  var tableViewCell: ITableViewCell { return TableViewCell() }
  
  func cell(_ tableView: UITableView, for indexPath: IndexPath) -> UITableViewCell {
    let reusableCell = tableView.dequeueReusableCell(withIdentifier: tableViewCell.reuseIdentifier,
                                                     for: indexPath) as? ConversationCell
    guard let cell = reusableCell else {
      return UITableViewCell()
    }
    
    cell.updateContent(with: self)
    
    return cell
  }
  
}
