//
//  FriendsControllerHelper.swift
//  ChatMesenger
//
//  Created by George Heints on 12/4/18.
//  Copyright © 2018 George Heints. All rights reserved.
//

import UIKit
import CoreData

let delegate = UIApplication.shared.delegate as! AppDelegate
let context = delegate.persistentContainer.viewContext

extension FriendsController{

    func clearData() {
        let delegate = UIApplication.shared.delegate as? AppDelegate

        if let context = delegate?.persistentContainer.viewContext {

            do {
                let entityNames = ["Friend", "Message"]
                for entityName in entityNames {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]

                    for object in objects! {
                        context.delete(object)
                    }
                }

                try(context.save())


            } catch let err {
                print(err)
            }

        }
    }

    func setupDate(){

        clearData()

        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext{
            let user = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend

            user.name = "George Heinz"
            user.profileImageName = "profile_3"


            let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message

            message.friend = user
            message.date = Date()

            let userTwo = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            userTwo.name = "Helena Mertinez"
            userTwo.profileImageName = "profile_1"

            let userThree = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            userThree.name = "Angel Perez"
            userThree.profileImageName = "profile_2"

            let userFour = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
            userFour.name = "James Kovalski"
            userFour.profileImageName = "profile_4"

            createMessageWithText(text: "Good morning...", friend: user, minutesAgo: 1, context: context)
            createMessageWithText(text: "Hey, where your computer", friend: user, minutesAgo: 2, context: context)
            createMessageWithText(text: "I could do it, but for what?", friend: user, minutesAgo: 5, context: context)
            createMessageWithText(text: "What is your name?", friend: user, minutesAgo: 6, context: context)
            createMessageWithText(text: "Leave me alone!", friend: user, minutesAgo: 12, context: context)

            createMessageWithText(text: "you want to come with me?", friend: userTwo, minutesAgo: 21, context: context)
            createMessageWithText(text: "sure...", friend: userTwo, minutesAgo: 5, context: context)
            createMessageWithText(text: "Ok, when we will meet. Ok, when we will meet. Ok, when we will meet. Ok, when we will meet", friend: userTwo, minutesAgo: 4, context: context)
            createMessageWithText(text: "Thats fine!", friend: userTwo, minutesAgo: 11, context: context)

            createMessageWithText(text: "Congratulations!", friend: userThree, minutesAgo: 11, context: context)
            createMessageWithText(text: "Thank you!", friend: userThree, minutesAgo: 60 * 24 * 8, context: context)

            createMessageWithText(text: "How are you?", friend: userFour, minutesAgo: 60 * 24, context: context)
            do{
                try(context.save())
            }catch let err{
                print(err)
            }
        }

        loadData()
    }

    
    private func createMessageWithText(text: String, friend: Friend, minutesAgo: Double, context: NSManagedObjectContext){
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context, isSender: Bool = false) as! Message
        message.friend = friend
        message.text = text
        message.date = Date().addingTimeInterval(minutesAgo * 60)
        message.isSender = NSNumber(bool: isSender)
    }
    
    func loadData(){
        let delegate = UIApplication.shared.delegate as? AppDelegate

        if let context = delegate?.persistentContainer.viewContext{

            if let friends = fetchFriends(){
                messages = [Message]()
                for friend in friends {

                    let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
                    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                    fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                    fetchRequest.fetchLimit = 1
                    do{

                        let fetchedMessages = try context.fetch(fetchRequest) as? [Message]
                        messages?.append(contentsOf: fetchedMessages!)
                    }catch let err{
                        print(err)
                    }
                }

                messages = messages?.sorted(by: ({$0.date!.compare($1.date!) == .orderedDescending}))
            }
        }
    }

    private func fetchFriends() -> [Friend]?{
        let delegate = UIApplication.shared.delegate as? AppDelegate

        if let context = delegate?.persistentContainer.viewContext{

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
            do{
                return try context.fetch(request) as? [Friend]
            }catch let err{
                print(err)
            }
        }
        return nil
    }
}
