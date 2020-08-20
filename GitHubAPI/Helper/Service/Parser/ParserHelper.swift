//
//  ParserHelper.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import CoreData
protocol Parseable {
    func parse<T: Decodable>(_ type: T.Type, from data: Data, userID: Int64?, completion: @escaping (Result<T, ErrorResult>) -> Void)
}

extension Parseable {
    /// Parsable data with local db using codable protocol
    /// - Parameters:
    ///   - type: class type generic
    ///   - data: data
    ///   - completion: completion handler
    func parse<T: Decodable>(_ type: T.Type, from data: Data, userID: Int64?, completion: @escaping (Result<T, ErrorResult>) -> Void) {
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (managedObjectContext) in
            managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            let decoder = JSONDecoder()

            //context store which use in manage object class
            if let context = CodingUserInfoKey.context {
                decoder.userInfo[context] = managedObjectContext
            }
            if let userID = userID, let userKey = CodingUserInfoKey.user {
                let predicate = NSPredicate(format: "id = %d", userID)
                if let user = CoreDataManager.shared.persistentContainer.viewContext.fetchData(entity: User.self,predicate: predicate).first as? User {
                    decoder.userInfo[userKey] = user
                }
            }
            
            do {
                let parseObject = try decoder.decode(type.self, from: data)
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                }
                completion(.success(parseObject))
            } catch {
                print(error)
                completion(.failure(.parser(string: error.localizedDescription)))
            }
        }
    }
}
