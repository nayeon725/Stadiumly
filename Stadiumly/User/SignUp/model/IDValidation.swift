import Foundation

struct IDUniqueRequest: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "user_cus_id"
    }
}

struct IDUniqueResponse: Codable {
    let message: String
    let status: String
} 