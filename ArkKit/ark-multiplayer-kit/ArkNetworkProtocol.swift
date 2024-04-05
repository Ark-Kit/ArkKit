//
//  ArkNetworkProtocol.swift
//  ArkKit
//
//  Created by Ryan Peh on 2/4/24.
//
import Foundation

protocol ArkNetworkProtocol {
    var delegate: ArkNetworkDelegate? { get set }
    var deviceID: String { get }

    init(serviceName: String)
    func sendData(data: Data)
    func sendData(_ data: Data, to peerName: String)
}
