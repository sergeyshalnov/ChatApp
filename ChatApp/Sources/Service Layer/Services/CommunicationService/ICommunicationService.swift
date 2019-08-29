//
//  NetworkProtocols.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicationService {
  
  var delegate: ICommunicationServiceDelegate? { get set }
  var session: MCSession? { get }
  
  func invite(peer: MCPeerID)
  func start(completion: @escaping Closure<Bool, ()>)
  func stop()
  
}

