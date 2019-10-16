//
//  UserVO+Extension.swift
//  netflixExercise
//
//  Created by Su Win Phyu on 10/5/19.
//  Copyright © 2019 swp. All rights reserved.
//

import Foundation
import CoreData

extension UserVO{
    static func saveUserVO(userId : Int,userName: String,avatar_path : String, context : NSManagedObjectContext){
        
        let user = UserVO(context: context)
        user.id = Int32(userId)
        user.username = String(userName)
        user.avatar_path = String(avatar_path)
        
        do{
            try context.save()
        }catch{
            print("Unable to save User Data ")
        }
    }
    
    static func getFetchRequest() -> NSFetchRequest<UserVO> {
        let fetchRequest : NSFetchRequest<UserVO> = UserVO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}

