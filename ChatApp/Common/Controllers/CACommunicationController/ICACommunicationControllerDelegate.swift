//
//  ICACommunicationControllerDelegate.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

protocol ICACommunicationControllerDelegate: class {
  
  func communicationController(_ communicationController: CACommunicationController,
                               peer: MCPeerID,
                               didReceiveInvitation invitationHandler: @escaping (Bool) -> ())
  
}
