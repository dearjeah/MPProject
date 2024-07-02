
# MPProject

MPProject is an app that let you to search your favorite musics from its title, artist, or albums name.




## Installation

No need to install, just run the .xcworkspace, then build and run.

After running in simulator/iPhone device, you will be prompt to put the 'Access Code' provided.
Copy and Paste the code and you can use it for one hour.

If it's not working, please directly email me.
    
## API Reference

API source from Spotify.
While the API can provide you to search the tracks, currently is not possible to playback the tracks.

#### Search tracks

```http
  https://api.spotify.com/v1
  GET /search
```
| Header | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `ContentType`      | `string` | **Required**. form |
| `Authorization`      | `string` | **Required**. basic <CLI_ID> + <CLI_SECRET> |

| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `q` | `string` | **Required**. Item that you want to search |
| `type` | `string` | **Required**. tracks,albums, artist, etc |

#### Get Token
Note: This API is currently unavailable to be run on app.

```http
  URL https://accounts.spotify.com
  GET /api/token
```

| Header | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `grant_type`      | `string` | **Required**. "client_credentials" |
| `ContentType`      | `string` | **Required**. form |
| `Authorization`      | `string` | **Required**. bearer <ACCESS_TOKEN> |

more info: https://api.spotify.com/




## Documentation

- Environment: Swift UIKit
- Architecture: MVVM
- Supporting patter: Singleton
- CI/CD: Fastlane Firebase
=========== PODS ============
- Layout: Snapkit
- Networking: Alamofire, SDwebImage, Kingfisher
- Debugging: FLEX, netfox
- Reactive: RxSwift
- Animation: Lottie




## FAQ

#### Why the token is not working in the app?

I currently seek out to know the cause, but for now it's because the API routing that I create cannot pass the 'grant_type' so it can't be called.

#### If you implement CI/CD with fastlane, why not share us the app through firebase?

Since my Apple Developer Account membership has been revoked for awhile , I can't build and uploading the IPA to firebase.


I apologize for the inconvinience while you testing this app.


## Support

For support (access token and other inquires), email me to del.work65@gmail.com.

