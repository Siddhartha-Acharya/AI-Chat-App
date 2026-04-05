//
//  AIChatDBManager.swift
//  AIChatApp
//
//  Created by selegic mac 01 on 04/04/26.
//

import SQLite
import Foundation

class AIChatDBManager {
    static let shared = AIChatDBManager()
    
    private var db: Connection!
    private let messages = Table("messages")
    
    private let id = Expression<Int64>("id")
    private let role = Expression<String>("role")
    private let content = Expression<String>("content")
    
    private init() {
        let path = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("chat.sqlite3").path
        
        db = try! Connection(path)
        
        try! db.run(messages.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(role)
            t.column(content)
        })
    }
    
    func insert(_ message: APIMessage) -> Int64? {
        let insert = messages.insert(
            role <- message.role,
            content <- message.content
        )
        
        do {
            return try db.run(insert)
        } catch {
            print("Insert error:", error)
            return nil
        }
    }
    
    func fetch() -> [APIMessage] {
        var result: [APIMessage] = []
        
        do {
            for row in try db.prepare(messages) {
                result.append(APIMessage(
                    id: row[id],
                    role: row[role],
                    content: row[content]
                ))
            }
        } catch {
            print("Fetch error:", error)
        }
        
        return result
    }
}
