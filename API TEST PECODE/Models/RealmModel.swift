//
//  RealmModel.swift
//  API TEST PECODE
//
//  Created by alekseienko on 15.10.2022.
//

import Foundation
import RealmSwift


final class ArticleObject: Object {
    @objc dynamic var author = ""
    @objc dynamic var title = ""
    @objc dynamic var articleDescription = ""
    @objc dynamic var url = ""
    @objc dynamic var urlToImage = ""
    @objc dynamic var publishedAt = ""
    @objc dynamic var content = ""
    @objc dynamic var articleSource: ArticleSourceObject? = ArticleSourceObject()
}

final class ArticleSourceObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
}

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
