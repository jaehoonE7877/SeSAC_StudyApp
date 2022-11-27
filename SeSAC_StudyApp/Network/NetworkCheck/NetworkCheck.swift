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
    private(set) var isConnected: Bool = false
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
    
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied
            // 최상위 뷰컨 확인해서 false 일때 alert 띄워줘야됨
            if self?.isConnected == true {
                
            } else {
               
            }
        }
    }
}
