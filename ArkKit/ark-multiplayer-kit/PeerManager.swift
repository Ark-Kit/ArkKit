//
//  PeerManager.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import MultipeerConnectivity

class PeerManager {
    private var peers: [MCPeerID: Int] = [:]
    private var nextID = 1

    func assignID(to peer: MCPeerID) -> Int {
        if let id = peers[peer] {
            return id  // Return existing ID if already assigned
        } else {
            peers[peer] = nextID
            nextID += 1
            return peers[peer]!  // Return new ID
        }
    }

    func id(for peer: MCPeerID) -> Int? {
        peers[peer]
    }

    func removePeer(_ peer: MCPeerID) {
        peers.removeValue(forKey: peer)
    }
}
