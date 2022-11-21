//
//  UserResponseDTO.swift
//  Mogakco
//
//  Created by 김범수 on 2022/11/21.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

struct UserResponseDTO: Decodable {
    private let id: StringValue
    private let name: StringValue
    private let email: StringValue
    private let languages: ArrayValue<StringValue>
    private let careers: ArrayValue<StringValue>
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, name, email, languages, careers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.name = try fieldContainer.decode(StringValue.self, forKey: .name)
        self.email = try fieldContainer.decode(StringValue.self, forKey: .email)
        self.languages = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .languages)
        self.careers = try fieldContainer.decode(ArrayValue<StringValue>.self, forKey: .careers)
    }
    
    init(user: User) {
        self.id = StringValue(value: user.id ?? "")
        self.name = StringValue(value: user.name)
        self.email = StringValue(value: user.email)
        self.languages = ArrayValue<StringValue>(values: user.languages.map { StringValue(value: $0) })
        self.careers = ArrayValue<StringValue>(values: user.careers.map { StringValue(value: $0) })
    }
    
    func toDomain() -> User {
        return User(
            id: id.value,
            email: email.value,
            password: nil,
            name: name.value,
            languages: languages.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } },
            careers: careers.arrayValue.map { $0.value }.flatMap { $0.map { $0.value } }
        )
    }
}
