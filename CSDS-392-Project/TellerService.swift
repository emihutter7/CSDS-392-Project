//
//  TellerService.swift
//  CSDS-392-Project
//
//  Created by Emi Hutter-DeMarco on 4/21/26.
//
import Foundation

final class TellerService {
    static let shared = TellerService()
    private init() {}

    private let baseURL = URL(string: "https://api.teller.io")!

    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "tellerSandboxAccessToken")
    }

    func loadAccessToken() -> String? {
        UserDefaults.standard.string(forKey: "tellerSandboxAccessToken")
    }

    func clearAccessToken() {
        UserDefaults.standard.removeObject(forKey: "tellerSandboxAccessToken")
    }

    private func makeRequest(path: String, accessToken: String) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let authString = "\(accessToken):"
        let authData = Data(authString.utf8)
        let encoded = authData.base64EncodedString()

        request.setValue("Basic \(encoded)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    func fetchAccounts(accessToken: String) async throws -> [TellerAccount] {
        let request = try makeRequest(path: "accounts", accessToken: accessToken)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([TellerAccount].self, from: data)
    }

    func fetchTransactions(accountId: String, accessToken: String) async throws -> [TellerTransaction] {
        let request = try makeRequest(path: "accounts/\(accountId)/transactions", accessToken: accessToken)
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([TellerTransaction].self, from: data)
    }
}
