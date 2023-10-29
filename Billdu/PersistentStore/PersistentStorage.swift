import Foundation
import SwiftData

protocol PersistentStorage {
    func delete<T>(model: T.Type, where predicate: Predicate<T>?, includeSubclasses: Bool) throws where T : PersistentModel
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T : PersistentModel
    func insert<T>(_ model: T) where T : PersistentModel
}

extension ModelContext: PersistentStorage { }


struct PreviewStorage: PersistentStorage {
    func delete<T>(model: T.Type, where predicate: Predicate<T>?, includeSubclasses: Bool) throws where T : PersistentModel {
        throw NSError(domain: "Not implemented", code: 0)
    }
    
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T : PersistentModel {
        []
    }
    
    func insert<T>(_ model: T) where T : PersistentModel {
        
    }
}
