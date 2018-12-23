//
//  CoreDataConfiguration.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataManager {
    
    func conversationFetchResultsController() -> NSFetchedResultsController<Conversation>
    func messageFetchResultsController(conversationId: String) -> NSFetchedResultsController<Message>
    
    func delete(request: NSFetchRequest<NSFetchRequestResult>, completion: @escaping (Bool) -> ())
    func terminate()
    
}

// MARK: - Profile Storage Interface

protocol IProfileStorage {
    
    func load(completion: @escaping (ProfileData?) -> ())
    func save(profile: ProfileData, completion: @escaping (Bool) -> ())
    
}


// MARK: - Communication Storage Interface

protocol ICommunicationStorage: IUserStorage, IConversationStorage, IMessageStorage {
    
    //
    
}


// MARK: - User Storage Interface

protocol IUserStorage {
    
    func add(user: UserData, completion: @escaping (String?) -> ())
    func delete(userId: String)
    
}

// MARK: - Conversation Storage Interface

protocol IConversationStorage {
    
    func edit(conversation: ConversationData) 
    func delete(conversationId: String)
    
}

// MARK: - Message Storage Interface

protocol IMessageStorage {
    
    func add(message: MessageData)
    
}
