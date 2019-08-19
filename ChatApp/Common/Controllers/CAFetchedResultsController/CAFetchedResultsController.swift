//
//  CAFetchedResultsTableViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 07/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit.UITableView
import CoreData

final class CAFetchedResultsController: NSObject {
  
  // MARK: - Variables
  
  private let fetchedResultsController: NSFetchedResultsController<NSManagedObject>
  private let tableView: UITableView
  
  // MARK: - Public
  
  var transform: CGAffineTransform = .identity {
    didSet {
      tableView.transform = transform
    }
  }
  
  var accessoryType: UITableViewCell.AccessoryType = .none
  
  // MARK: - Init
  
  init(_ fetchedResultsController: NSFetchedResultsController<NSManagedObject>, for tableView: UITableView) {
    self.fetchedResultsController = fetchedResultsController
    self.tableView = tableView
    
    super.init()
    setup()
  }
  
}

// MARK: - Setup

private extension CAFetchedResultsController {
  
  func setup() {
    tableView.dataSource = self
    fetchedResultsController.delegate = self
  }
  
}

// MARK: - Open Interface

extension CAFetchedResultsController {
  
  func performFetch() {
    do {
      try fetchedResultsController.performFetch()
    } catch {
      #if DEBUG
      print(error.localizedDescription)
      #endif
    }
  }
  
  func item<T>(at indexPath: IndexPath) -> T? {
    return fetchedResultsController.object(at: indexPath) as? T
  }
  
}

// MARK: - UITableViewDataSource

extension CAFetchedResultsController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = fetchedResultsController.sections else {
      return 0
    }
    
    return sections[section].numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let model = fetchedResultsController.object(at: indexPath) as? ITableViewModel else {
      return UITableViewCell()
    }
    
    let cell = model.cell(tableView, for: indexPath)
    
    cell.transform = transform
    cell.accessoryType = accessoryType
    
    return cell
  }
  
}

// MARK: - NSFetchedResultsControllerDelegate

extension CAFetchedResultsController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    switch type {
    case .delete:
      tableView.deleteRows(at: [indexPath ?? []], with: .automatic)
    case .insert:
      tableView.insertRows(at: [newIndexPath ?? []], with: .top)
    case .move:
      guard
        let indexPath = indexPath,
        let newIndexPath = newIndexPath
        else {
          return
      }
      
      tableView.moveRow(at: indexPath, to: newIndexPath)
    case .update:
      tableView.reloadRows(at: [indexPath ?? []], with: .automatic)
    @unknown default:
      return
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}
