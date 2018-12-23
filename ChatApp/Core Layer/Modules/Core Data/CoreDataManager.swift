//
//  CoreDataManager.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 15/11/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit
import CoreData


// MARK: - Core Data Manager

class CoreDataManager: ICoreDataManager, ICommunicationStorage {
    
    private static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { _, _ in })
        return container
    }()
    
    func conversationFetchResultsController() -> NSFetchedResultsController<Conversation> {
        let fetchRequest = NSFetchRequest<Conversation>(entityName: String(describing: Conversation.self))
        
        fetchRequest.sortDescriptors = Conversation.defaultSortDescriptors
        fetchRequest.resultType = .managedObjectResultType
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: CoreDataManager.container.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        return controller
    }
    
    func messageFetchResultsController(conversationId: String) -> NSFetchedResultsController<Message> {
        let fetchRequest = NSFetchRequest<Message>(entityName: String(describing: Message.self))
        
        fetchRequest.sortDescriptors = Message.defaultSortDescriptors
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.predicate = Message.defaultPredicate(conversationId: conversationId)
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: CoreDataManager.container.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        
        return controller
    }
    
    func delete(request: NSFetchRequest<NSFetchRequestResult>, completion: @escaping (Bool) -> ()) {
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        let context = CoreDataManager.container.viewContext
        
        context.performAndWait {
            do {
                try context.execute(delete)
                try context.save()
                
                completion(true)
            } catch {
                completion(false)
            }
        }
    }
    
    func terminate() {
        let conversartionRequest = NSBatchDeleteRequest(fetchRequest: Conversation.fetchRequest())
        let userRequest = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
        let messageRequest = NSBatchDeleteRequest(fetchRequest: Message.fetchRequest())

        let context = CoreDataManager.container.viewContext

        context.performAndWait {
            do {
                try context.execute(conversartionRequest)
                try context.execute(userRequest)
                try context.execute(messageRequest)
                try context.save()
            } catch {
                return
            }
        }
        
    }
    
}


// MARK: - Profile Data Manager

extension CoreDataManager: IProfileStorage {
    
    func load(completion: @escaping (ProfileData?) -> ()) {
        CoreDataManager.container.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Profile> = Profile.fetchRequest()
            
            do {
                let result = try backgroundContext.fetch(request)
                let data = result.first
                
                var image: UIImage? = nil
                
                if let url = data?.image {
                    let imageLoader: IImageLoader = ImageManager()
                    
                    image = imageLoader.load(filename: url)
                }
                
                completion(ProfileData(username: data?.username, information: data?.information, image: image))
            } catch {
                completion(nil)
            }
        }
    }
    
    func save(profile: ProfileData, completion: @escaping (Bool) -> ()) {
        CoreDataManager.container.performBackgroundTask { (backgroundContext) in
            let request: NSFetchRequest<Profile> = Profile.fetchRequest()
            
            do {
                let result = try backgroundContext.fetch(request)
                var success = true
                
                if result.isEmpty {
                    let entity = Profile(context: backgroundContext)
                    
                    if let username = profile.username {
                        entity.username = username
                    }
                    
                    if let information = profile.information {
                        entity.information = information
                    }
                    
                    if let image = profile.image {
                        let imageSaver: IImageSaver = ImageManager()
                        
                        success = imageSaver.save(image: image, filename: FileName.image.rawValue)
                        entity.image = success ? FileName.image.rawValue : nil
                    }
                } else {
                    let entity = result.first
                    
                    if let username = profile.username {
                        entity?.setValue(username, forKey: "username")
                    }
                    
                    if let information = profile.information {
                        entity?.setValue(information, forKey: "information")
                    }
                    
                    if let image = profile.image {
                        let imageSaver: IImageSaver = ImageManager()
                        
                        success = imageSaver.save(image: image, filename: FileName.image.rawValue)
                        entity?.setValue(FileName.image.rawValue, forKey: "image")
                    }
                }
                
                try backgroundContext.save()
                
                completion(success)
            } catch {
                completion(false)
                
                return
            }
        }
    }
}

// MARK: - User Storage Manager

extension CoreDataManager: IUserStorage {
    
    func add(user: UserData, completion: @escaping (String?) -> ()) {
        
        let online = user.online
        let name = user.username
        
        let context = CoreDataManager.container.viewContext
        do {
            let conversation = Conversation(context: context)
            let user = User(context: context)
            
            user.conversation = conversation
            user.name = name
            user.online = online
            user.userId = "U" + Generator.id()
            
            conversation.user = user
            conversation.conversationId = "C" + Generator.id()
            
            try context.save()
            
            completion(conversation.conversationId)
        } catch {
            completion(nil)
            return
        }
        
    }
    
    func delete(userId: String) {
        let DataManager = CoreDataManager()
        
        let request: NSFetchRequest<NSFetchRequestResult> = User.fetchRequest()
        let predicate = User.userPredicate(id: userId)
        request.predicate = predicate
        
        DataManager.delete(request: request) { success in
            print("User delete : \(success)")
        }
    }
    
}


// MARK: - Conversation Storage Manager

extension CoreDataManager: IConversationStorage {
    
    func edit(conversation: ConversationData) {
        let context = CoreDataManager.container.viewContext
        
        context.performAndWait {
            do {
                let request = Conversation.conversationFetchRequest(id: conversation.conversationId)
                let conversations = try context.fetch(request)
                let entity = conversations.first
                
                entity?.wasUnreadMessages = conversation.wasUnreadMessages
                
                if conversation.lastMessage != nil && conversation.lastMessageDate != nil {
                    entity?.lastMessage = conversation.lastMessage
                    entity?.lastMessageDate = conversation.lastMessageDate
                }
                
                try context.save()
                
            } catch {
                print("Edit converstion fail")
                return
            }
        }
        
    }
    
    func delete(conversationId: String) {
        let DataManager: ICoreDataManager = CoreDataManager()
        let request: NSFetchRequest<NSFetchRequestResult> = Conversation.fetchRequest()
        let predicate = Conversation.conversationPredicate(id: conversationId)
        request.predicate = predicate
        
        DataManager.delete(request: request) { success in
            print("Conversation delete : \(success)")
        }
    }
    
}


// MARK: - Message Storage Manager

extension CoreDataManager: IMessageStorage {
    
    func add(message: MessageData) {
        let context = CoreDataManager.container.viewContext
        
        context.performAndWait {
            do {
                let request = Conversation.conversationFetchRequest(id: message.conversationId)
                let conversations = try context.fetch(request)
                let conversation = conversations.first
                
                let entity = Message(context: context)
                entity.conversation = conversation
                entity.text = message.text
                entity.date = message.date
                entity.incoming = message.incoming
                entity.messageId = message.messageId
                
                conversation?.addToMessages(entity)
                conversation?.lastMessageDate = message.date
                conversation?.lastMessage = message.text
                
                try context.save()
            } catch {
                return
            }
       }
    }
    
}
