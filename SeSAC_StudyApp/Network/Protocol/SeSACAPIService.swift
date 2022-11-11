//
//  SeSACAPIService.swift
//  SeSAC_StudyApp
//
//  Created by Seo Jae Hoon on 2022/11/09.
//

import Foundation

protocol SeSACAPIService {
    func request()
    //func request<T: Decodable>(type: T.Type = T.self, router: SeSACAPIRouter, completion: (Result<T, SeSACError>) -> Void)
}
