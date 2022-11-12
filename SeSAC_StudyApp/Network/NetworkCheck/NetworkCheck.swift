//
//  NetworkCheck.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/12.
//

import Foundation
import Network

final class NetworkCheck {
    static let shared = NetworkCheck()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied
            
            if self?.isConnected == true {
                print("연결됨")
            } else {
                //showNetworkVCOnRoot()
            }
        }
    }
}
