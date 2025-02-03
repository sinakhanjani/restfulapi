# RestfulAPI

**RestfulAPI** is a lightweight, yet powerful Swift framework designed for seamless interaction with RESTful web services. It provides an easy-to-use API built on top of `URLSession` and `Combine`, supporting modern asynchronous programming patterns. With built-in authentication management, multiple request execution methods, and structured response handling, this framework simplifies network operations in iOS applications.

## ✨ Key Features
- **Easy API Requests** – Simplified request handling with `URLSession` and `Combine`
- **Multiple Execution Methods** – Support for `DispatchQueue`, `DispatchSemaphore`, and `async/await`
- **Authentication Management** – Built-in token-based authentication with `Authentication` and `AuthorizationType`
- **Custom Headers Support** – Easily attach custom headers to API requests
- **Automatic Encoding & Decoding** – JSON serialization support for request bodies and responses
- **Swift Package Manager (SPM) Support** – Easy integration into projects

## 🛠 Installation
### Swift Package Manager (SPM)
Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/your-repo/RestfulAPI.git", from: "1.0.0")
]
```

Or use Xcode’s `File > Swift Packages > Add Package Dependency` and enter the repository URL.

## ⚙️ Configuration
Before making requests, configure the API settings:

```swift
RestfulAPIConfiguration().setup { () -> APIConfiguration in
    APIConfiguration(baseURL: "https://your-api.com",
                     headers: ["Authorization": "Bearer token"])
}
```

## 🔐 Authentication
This framework provides built-in authentication management:

### 1️⃣ Setting Authentication Type
You can set the type of authentication using `AuthorizationType`:

```swift
public enum AuthorizationType: Codable {
    case bearerToken
    case token
    case basicAuth
}
```

### 2️⃣ Managing Authentication Tokens
The `Authentication` class helps in managing tokens:

```swift
var auth = Authentication.auth1

// Authenticate a user
auth.authenticate(token: "your_token_here")

// Check if user is logged in
if auth.isLogin {
    print("User is logged in")
}

// Logout user
auth.logout()
```

## 🚀 Usage

### 1️⃣ Fetch with `Combine`
Use `fetchDataTaskPublisherRequest` for handling API responses using `Combine`:

```swift
var fetchRequest = RestfulAPI<Empty, Example>(path: "/todos/1")
    .with(method: .GET)

fetchRequest
    .fetchDataTaskPublisherRequest { result in
        switch result {
        case .success(let example):
            print(example)
        case .failure(let error):
            print("Error:", error)
        }
    }
```

### 2️⃣ Fetch with `URLSession` (Completion Handler)
Use `sendURLSessionRequest` for handling API responses with a completion handler:

```swift
RestfulAPI<Empty, Example>(path: "/todos/1")
    .sendURLSessionRequest { result in
        switch result {
        case .success(let example):
            print(example)
        case .failure(let error):
            print("Error:", error)
        }
    }
```

### 3️⃣ Fetch with `DispatchSemaphore` (Synchronous Request)
Use this method when you need to wait for the API response synchronously:

```swift
let response = try? RestfulAPI<Empty, Example>(path: "/todos/1")
    .sendURLSessionRequest()
```

### 4️⃣ Adding Headers
You can add custom headers to your API requests:

```swift
RestfulAPI<Empty, Example>(path: "/todos/1")
    .with(headers: ["Custom-Header": "Value"])
```

### 5️⃣ Encoding & Decoding Response
The framework provides built-in methods for encoding requests and decoding responses:

```swift
public func decodeResponse(data: Data) throws -> Response
public func encodeResponse() throws -> Data
```

### 6️⃣ Available HTTP Methods
The following HTTP methods are supported:

```swift
public enum Method: String {
    case GET, POST, PUT, DELETE, PATCH
}
```

## 📝 License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## 💡 Contributing
Contributions are welcome! Feel free to create issues or submit pull requests.

---

This `README.md` now includes structured documentation with headers, proper explanations, and a cleaner format for better readability.

