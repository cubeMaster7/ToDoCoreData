//
//  ToDoList+CoreDataProperties.swift
//  ToDoCoreData
//
//  Created by Paul James on 27.10.2021.
//
//

import Foundation
import CoreData


extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var title: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var priority: Int32
    @NSManaged public var orderID: Int32

}

extension ToDoList : Identifiable {

}
