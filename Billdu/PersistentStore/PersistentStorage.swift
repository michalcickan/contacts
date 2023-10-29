import Foundation
import SwiftData

protocol PersistentStorage {
    func delete<T>(_ model: T) where T : PersistentModel
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T : PersistentModel
    func insert<T>(_ model: T) where T : PersistentModel
}

extension ModelContext: PersistentStorage { }


struct PreviewStorage: PersistentStorage {
    public func delete<T>(_ model: T) where T : PersistentModel {
        
    }
    
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T : PersistentModel {
        []
    }
    
    func insert<T>(_ model: T) where T : PersistentModel {
        
    }
}
