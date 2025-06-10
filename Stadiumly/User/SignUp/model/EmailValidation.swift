import Foundation

struct EmailUniqueRequest: Codable {
    let email: String
}

struct EmailUniqueResponse: Codable {
    let message: String
    let status: String
}

struct EmailTokenCheckRequest: Codable {
    let email: String
    let emailToken: String
}

struct EmailTokenCheckResponse: Codable {
    let message: String
    let status: String
} 

struct FindIdEmailVerifyRequest: Codable {
    let user_email: String
    let token: String
}
