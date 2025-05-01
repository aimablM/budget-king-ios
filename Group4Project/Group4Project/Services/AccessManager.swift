import SwiftUI
import LinkKit

let reqURL = ""
var JWT = ""

struct User: Codable {
    let email: String
    let password: String
}

final class AccessManager: ObservableObject {
    static let shared = AccessManager()
    private weak var viewModel: AppViewModel?
    
    @ObservedObject private var controller = PlaidLinkController()
    
    init() {}
    
    // Add method to setup connection with AppViewModel
    func setup(viewModel: AppViewModel) {
        self.viewModel = viewModel
    }
    
    func logIn(email: String, password: String) async throws {
        let user = User(email: email, password: password)
        
        guard let url = URL(string: "http://localhost:3000/api/login")
        else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print(error)
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid response or status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            print(httpResponse.statusCode)
            
            if let data = data {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonDict = responseJSON as? [String: Any],
                   let token = jsonDict["token"] as? String {
                    JWT = token
                    
                    // Update viewModel on successful login
                    DispatchQueue.main.async {
                        self?.viewModel?.loggedIn = true
                    }
                    
                    print("Response JSON:", responseJSON)
                } else if let responseString = String(data: data, encoding: .utf8) {
                    print("Response String:", responseString)
                }
            }
        }.resume()
    }
    
    func register(email: String, password: String) async throws {
        let user = User(email: email, password: password)
        
        guard let url = URL(string: "http://localhost:3000/api/register")
        else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print(error)
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid response or status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            print(httpResponse.statusCode)
            
            if let data = data {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonDict = responseJSON as? [String: Any],
                   let token = jsonDict["token"] as? String {
                    JWT = token
                    
                    // Update viewModel on successful registration
                    DispatchQueue.main.async {
                        self?.viewModel?.loggedIn = true
                    }
                } else if let responseString = String(data: data, encoding: .utf8) {
                    print("Response String:", responseString)
                }
            }
        }.resume()
    }
    
    func createLinkToken() async throws {
        guard let url = URL(string: "http://localhost:3000/api/create_link_token")
        else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(JWT)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            
            if let error = error {
                print("Error:", error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid response or status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            print(httpResponse.statusCode)
            
            if let data = data {
                do {
                    if let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let token = responseJSON["link_token"] as? String {
                            print("Received link token: \(token)")
                            
                            // Use the token to create a link config
                            self?.controller.createLinkConfig(token: token)
                            
                            // Update viewModel on successful link token creation
                            DispatchQueue.main.async {
                                self?.viewModel?.bankLinked = true
                            }
                        } else {
                            print("link_token not found in response")
                        }
                    } else {
                        print("Could not parse JSON as [String: Any]")
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    // Template for future getTransactions method
    func getTransactions() async throws -> [Transaction] {
        // This will be implemented in the future to fetch transactions from backend
        // For now, just return an empty array
        return []
    }
}

// No changes needed to PlaidLinkController
class PlaidLinkController: UIViewController, ObservableObject {
    var handler: Handler?
    
    func createLinkConfig(token: String) {
        let config = LinkTokenConfiguration(
            token: token,
            onSuccess: { linkSuccess in
                // Send the linkSuccess.publicToken to your app server.
            }
        )
        
        let result = Plaid.create(config)
        switch result {
        case .failure(let error):
            print(error)
        case .success(let handler):
            self.handler = handler
            handler.open(presentUsing: .viewController(self))
        }
    }
}
