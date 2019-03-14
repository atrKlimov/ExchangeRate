//
//  NBU.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 12.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import Foundation
import PromiseKit
import Moya

public enum NBU {
    case all(date: String)
    case single(currencyCode: String)
}

extension NBU: TargetType {
    public var baseURL: URL {
        return URL(string: "https://bank.gov.ua/NBUStatService/v1/statdirectory")!
    }
    
    public var path: String {
        switch self {
            case .all(let date): return "/exchange?date=\(date)&json"
            case .single(let currencyCode): return "/exchange?valcode=\(currencyCode)&json"
        }
    }
    public var method: Moya.Method {
        switch self {
            case .all: return .get
            case .single: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    static func APIcall(target: NBU) -> Promise<[Currency]> {
        let provider = MoyaProvider<NBU>()
        return Promise { seal in
            provider.request(target, completion: { result in
            switch result {
                case .success(let response):
                    do{
                        let decoder = JSONDecoder()
                        let data = try decoder.decode([Currency].self, from: response.data)
                        seal.fulfill(data)
                    } catch let error {
                        seal.reject(error)
                }
                case .failure(let error):
                    seal.reject(error)
                }
            })
        }
    }
    
    
}
