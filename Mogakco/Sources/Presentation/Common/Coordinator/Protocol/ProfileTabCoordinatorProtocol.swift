//
//  ProfileTabCoordinatorProtocol.swift
//  Mogakco
//
//  Created by 신소민 on 2022/11/17.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import Foundation

protocol ProfileTabCoordinatorProtocol: AnyObject {
    func showProfile()
    func showEditProfile()
    func showChatDetail(chatRoomID: String)
    func showSelectHashtag(kindHashtag: KindHashtag)
    func editFinished()
}
