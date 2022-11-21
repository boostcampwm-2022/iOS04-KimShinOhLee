//
//  SignupResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/16.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct SignupResponseDTO: Decodable {
    // TODO: private
    let id: String
    let email: String
    let name: String
    let languages: [String]
    let careers: [String]
    
    func toDomain() -> User {
        return User(
            id: id,
            email: email,
            password: nil,
            name: name,
            languages: languages,
            careers: careers
        )
    }
}
