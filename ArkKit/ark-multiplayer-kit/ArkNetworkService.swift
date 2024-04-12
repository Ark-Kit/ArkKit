//
//  ArkNetworkService.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import UIKit
import P2PShare

class ArkNetworkService: ArkNetworkProtocol {
    private let myPeerInfo = PeerInfo(["name": UIDevice.current.name])
    private var peers: [PeerInfo] = []
    private var session: MultipeerSession!
    var delegate: ArkNetworkDelegate?
    private(set) var serviceName: String

    required init(serviceName: String = "Ark") {
        let config = MultipeerSessionConfig(myPeerInfo: myPeerInfo,
                                            bonjourService: "_ArkMultiplayer._tcp",
                                            presharedKey: "12345",
                                            identity: "testing")
        self.session = MultipeerSession(config: config, queue: .main)
        self.serviceName = serviceName
        setUpHandlers()

        session.startSharing()
    }

    deinit {
        session.stopSharing()
    }

    var deviceID: String {
        myPeerInfo.peerID
    }

    private func setUpHandlers() {
        self.session.peersChangeHandler = { [weak self] peers in
            guard let strongSelf = self else {
                return
            }

            strongSelf.peers = peers
            strongSelf.delegate?.connectedDevicesChanged(manager: strongSelf, connectedDevices: peers.map { $0.peerID })
            print("Peers changed: \(peers.map { $0.info["name"] ?? $0.peerID })")
        }

        self.session.newPeerHandler = { peer in
            print("New peer joined: \(peer.info["name"] ?? peer.peerID)")
        }

        self.session.messageReceivedHandler = { [weak self] _, data in
            self?.delegate?.gameDataReceived(manager: self!, gameData: data)
        }
    }

    func sendData(data: Data) {
        if !self.peers.isEmpty {
            session.sendToAllPeers(data: data)
        }
    }

    func sendData(_ data: Data, to peerName: String) {
        guard let peerInfo = peers.first(where: { $0.info["name"] == peerName }) else {
            return
        }

        session.send(to: peerInfo.peerID, data: data)
    }
}

// MARK: - ArkNetworkDelegate

protocol ArkNetworkDelegate: AnyObject {
    func connectedDevicesChanged(manager: ArkNetworkService, connectedDevices: [String])
    func gameDataReceived(manager: ArkNetworkService, gameData: Data)
}
