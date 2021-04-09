import Foundation

public struct ListingResponse<T: Decodable>: Decodable {
    public let result: Int?
    public let code: Int?
    public let data: ListingData<T>?
    public let message: String?
}

public struct ListingData<T: Decodable>: Decodable {
    public let detail: String?
    public let items: [T]
}
