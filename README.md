# XaynSDK

Simple wrapper around personalized documents, interactions and documents APIs, written in Swift.
Every method has an async equivalent.


----------



## Table of content:

 * [Installing :hammer_and_wrench:](#installing-hammer_and_wrench)
 * [How to use :building_construction:](#how-to-use-building_construction)
 * [License :scroll:](#license-scroll)

----------



## Installing :hammer_and_wrench:

To use the SDK in your project, install it using Swift Package Manager by adding a new package from Xcode.

----------



## How to use :building_construction:

Import the SDK.
```swift
import SwiftSDK
```

Initialize the client with a User ID.
```swift
let client = XaynClient(userId: UUID())
```

Use the client to call an API.
```swift
let response = try await client.personalizedDocuments()
```

To change the User ID, use the `updateUserId()` method, passing the new User ID.
```swift
client.updateUserId(UUID())
```


Please also give a try to the [example app](../main/example/)

----------


## License :scroll:
**XaynSDK** is licensed under `Apache 2`. View [license](../main/LICENSE).

----------
