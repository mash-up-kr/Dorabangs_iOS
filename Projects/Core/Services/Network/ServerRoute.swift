//
//  ServerRoute.swift
//  Services
//
//  Created by 박소현 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public enum ServerRoute: Equatable {
    case api(Api)
    
    public struct Api: Equatable {
        
        public enum Route: Equatable, Sendable {
            case config
        }
    }
}
