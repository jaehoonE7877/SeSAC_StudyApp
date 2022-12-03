//
//  SeSACAPIService.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

import Alamofire

final class DefaultSeSACAPIService {
    
    static let shared = DefaultSeSACAPIService()
        
    private init() { }
    
    func request<T: Decodable>(type: T.Type = T.self, router: SeSACAPIRouter, completion: @escaping (Result<T, SeSACError>) -> Void) {
        
        AF.request(router).responseDecodable(of: type) { response in
            switch response.result {

            case .success(let data):
                completion(.success(data)) //탈출클로저, result타입, 열거형, 연관값,
            case .failure(_):

                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SeSACError(rawValue: statusCode) else { return }

                completion(.failure(error))
            }
        }
    }
    
    func requestQueue<T: Decodable>(type: T.Type = T.self, router: SeSACAPIRouter, completion: @escaping (Result<T, SeSACSearchError>) -> Void) {
        
        AF.request(router).responseDecodable(of: type) { response in
            switch response.result {

            case .success(let data):
                completion(.success(data)) //탈출클로저, result타입, 열거형, 연관값,
            case .failure(_):

                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SeSACSearchError(rawValue: statusCode) else { return }

                completion(.failure(error))
            }
        }
    }
    
    func requestSeSACAPI(router: SeSACAPIRouter, completion: @escaping (Int) -> Void){
        AF.request(router).responseString { response in
            
            guard let statusCode = response.response?.statusCode else { return }
            
            completion(statusCode)
        }
    }
    
    func postChat<T: Decodable>(type: T.Type = T.self, router: SeSACAPIRouter, completion: @escaping (Result<T, SeSACChatError>) -> Void) {
        AF.request(router).responseDecodable(of: type) { response in
            switch response.result {
                
            case .success(let data):
                completion(.success(data)) 
            case .failure(_):
                
                guard let statusCode = response.response?.statusCode else { return }
                guard let error = SeSACChatError(rawValue: statusCode) else { return }
                
                completion(.failure(error))
            }
        }
    }
}
