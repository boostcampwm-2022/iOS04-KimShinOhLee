//
//  ChatRoomListCoordinator.swift
//  Mogakco
//
//  Created by 신소민 on 2022/12/03.
//  Copyright © 2022 Mogakco. All rights reserved.
//

import UIKit

import RxSwift

enum ChatRoomListCoordinatorResult { }

final class ChatRoomListCoordinator: BaseCoordinator<ChatRoomListCoordinatorResult> {
    
    override func start() -> Observable<ChatRoomListCoordinatorResult> {
        showChatRoomList()
        return Observable.never()
    }
    
    // MARK: - 채팅방 목록
    
    func showChatRoomList() {
        let viewModel = ChatListViewModel(
            chatRoomListUseCase: ChatRoomListUseCase(
                chatRoomRepository: ChatRoomRepository(
                    chatRoomDataSource: ChatRoomDataSource(provider: Provider.default),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default),
                    studyDataSource: StudyDataSource(provider: Provider.default)
                ),
                userRepository: UserRepository(
                    localUserDataSource: UserDefaultsUserDataSource(),
                    remoteUserDataSource: RemoteUserDataSource(provider: Provider.default)
                )
            )
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .chatRoom(let id):
                    self?.showChatRoom(id: id)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = ChatListViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
    // MARK: - 채팅방
    
    func showChatRoom(id: String) {
        let chatRoom = ChatRoomCoordinator(id: id, navigationController)
        coordinator(to: chatRoom)
            .subscribe(onNext: {
                switch $0 {
                case .back: break
                }
            })
            .disposed(by: disposeBag)
    }
}
