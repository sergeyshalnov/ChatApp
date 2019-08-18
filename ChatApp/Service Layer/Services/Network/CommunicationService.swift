//
//  CommunicationService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationService: NSObject {
  
  // MARK: - Delegate
  
  weak var delegate: ICommunicationServiceDelegate?
  
  // MARK: - Variables
  
  private(set) var session: MCSession
  
  private let peer: MCPeerID
  private let browser: MCNearbyServiceBrowser
  private let advertiser: MCNearbyServiceAdvertiser
  private let discoveryInfo: [String: String]
  private let dataParser: DataParser<MessageModel>
  
  private let serviceType = "text-chat"
  
  // MARK: - Init
  
  init(username: String, dataParser: DataParser<MessageModel>) {
    self.dataParser = dataParser
    
    discoveryInfo = ["username": username]
    peer = MCPeerID(displayName: username)
    session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)
    browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
    advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: discoveryInfo, serviceType: serviceType)
    
    super.init()
    
    session.delegate = self
    browser.delegate = self
    advertiser.delegate = self
    
    CoreDataManager().terminate()
  }
  
  // MARK: - Deinit
  
  deinit {
    stop()
  }
  
}

// MARK: - ICommunicationService

extension CommunicationService: ICommunicationService {
  
  func start() {
    browser.startBrowsingForPeers()
    advertiser.startAdvertisingPeer()
  }
  
  func stop() {
    browser.stopBrowsingForPeers()
    advertiser.stopAdvertisingPeer()
  }
  
  func invite(peer: MCPeerID) {
    browser.invitePeer(peer, to: session, withContext: nil, timeout: 300)
  }
  
}

// MARK: - MCSessionDelegate

extension CommunicationService: MCSessionDelegate {
  
  func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?,
               fromPeer peerID: MCPeerID,
               certificateHandler: @escaping (Bool) -> Void) {
    
    certificateHandler(true)
  }
  
  func session(_ session: MCSession, didReceive: Data, fromPeer: MCPeerID) {
    guard let message = dataParser.parse(data: didReceive) else {
      return
    }
    
    DispatchQueue.main.async {
      self.delegate?.communicationService(self, didReceiveMessage: message, from: fromPeer)
    }
  }
  
  func session(_ session: MCSession,
               didStartReceivingResourceWithName: String,
               fromPeer: MCPeerID,
               with: Progress) {
    
    #if DEBUG
    let log = """
              Peer \"\(fromPeer.displayName)\" did start receiving resource with name
              \"\(didStartReceivingResourceWithName)\", progress: \(with.debugDescription)"
              """
    
    print(log)
    #endif
  }
  
  func session(_ session: MCSession,
               didFinishReceivingResourceWithName: String,
               fromPeer: MCPeerID,
               at: URL?,
               withError: Error?) {
    
    #if DEBUG
    let log = """
              Peer \"\(fromPeer.displayName)\" did finish receiving resource
              with name \"\(didFinishReceivingResourceWithName)\"
              """
    
    print(log)
    #endif
  }
  
  func session(_ session: MCSession,
               didReceive: InputStream,
               withName: String,
               fromPeer: MCPeerID) {
    
    #if DEBUG
    print("Peer \"\(fromPeer.displayName)\" did receive stream with name \"\(withName)\"")
    #endif
  }
  
  func session(_ session: MCSession,
               peer peerID: MCPeerID,
               didChange: MCSessionState) {
    
    #if DEBUG
    switch didChange {
    case .connected:
      print("Peer \"\(peerID.displayName)\" connected")
    case .connecting:
      print("Peer \"\(peerID.displayName)\" is connecting")
    case .notConnected:
      print("Peer \"\(peerID.displayName)\" not connected")
    @unknown default:
      print("Peer \"\(peerID.displayName)\" have unknow MCSessionState")
    }
    #endif
    
    delegate?.communicationService(self, didChange: didChange, from: peerID)
  }
  
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension CommunicationService: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                  didReceiveInvitationFromPeer peerID: MCPeerID,
                  withContext context: Data?,
                  invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    delegate?.communicationService(self, didReceiveInviteFromPeer: peerID) { [weak self] (isAccepted) in
      invitationHandler(isAccepted, self?.session)
    }
  }
  
}

// MARK: - MCNearbyServiceBrowserDelegate

extension CommunicationService: MCNearbyServiceBrowserDelegate {
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    delegate?.communicationService(self, didLostPeer: peerID)
  }
  
  func browser(_ browser: MCNearbyServiceBrowser,
               foundPeer peerID: MCPeerID,
               withDiscoveryInfo info: [String : String]?) {
    
    delegate?.communicationService(self, didFoundPeer: peerID)
  }
  
}
