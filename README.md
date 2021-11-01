# GifCollectionView

![CocoaPods](https://img.shields.io/cocoapods/v/GifCollectionView.svg)

Drop in GIF Collection View. Uses Tenor as default GIFs provider. This will allow you to easily integrate GIF image search into your app or you can use this as a GIF keyboard for your messaging needs. You can also use `TenorAPIManager` to use Endpoints provided by Tenor API.

### The library consists of 2 major components

1. **GifCollectionView**, which provides a simple View for search, and callbacks for selected images so you can quickly integrate GIFs in to your app. You can also implement your own `GifProvider` with another GIF service (e.g: GIPHY) and supply the provider to `GifCollectionView`.

2. **TenorAPIManager**, which provides an API layer to access Tenor. This does not require you to use GifCollectionView, and can be used standalone. 


![Demo](https://github.com/tamimNumrah/GifCollectionView/blob/main/demo.gif)


## Requirements

- iOS 12.0+ | macOS 10.15+
- Xcode 13

## Integration

#### CocoaPods (iOS 12.0+, OS X 10.15+)

You can use [CocoaPods](http://cocoapods.org/) to install `GifCollectionView` by adding it to your `Podfile`:

```ruby
platform :ios, '12.0'
use_frameworks!

target 'MyApp' do
    pod 'GifCollectionView'
end
```

## Usage

#### Initialization

```swift
import GifCollectionView
```

Simply initialize `GifCollectionView` like any other view and provide appropriate constraints. 

```swift
gifCollectionView = GifCollectionView.init()
gifCollectionView.delegate = self
view.addSubview(gifCollectionView)
```
In order to load Gifs using Tenor you must supply your own Tenor API Key. 

```swift
gifCollectionView.setTenorApiKey(apiKey: "YOUR_TENOR_API_KEY")
gifCollectionView.startLoadingGifs()
```

Or you can supply your own Gifs provider by conforming to `GifProvider` protocol

```swift
gifCollectionView.replaceProvider(<#T##provider: GifProvider##GifProvider#>)
gifCollectionView.startLoadingGifs()
```

You can receive callbacks for selected images using `GifCollectionViewDelegate`. 

```swift
public protocol GifCollectionViewDelegate: AnyObject {
    func didSelectGifItem(gifItem: GifItem)
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}
```

## Tenor APIs

There are many endpoints provided by Tenor such as `Search`, `Trending GIFs` etc. Which you can easily use by initializing dedicaed endpoint structs such as `TenorEndpointSearch` and `TenorEndpointTrending`.

#### TenorAPIManager Initialization

```swift
let apiManager = TenorAPIManager()
```
#### Usage of Endpoints

```swift
let search = TenorEndpointSearch.init(key: "YOUR_TENOR_API_KEY", q: "SearchText")
apiManager.makeTenorWebRequest(endpoint: search) { success, response in                
}
```

```swift
let trending = TenorEndpointTrending.init(key: "YOUR_TENOR_API_KEY")
apiManager.makeTenorWebRequest(endpoint: trending) { success, response in                
}
```


## Questions
If you have questions on how to integrate GifCollectionView into your project, feel free to create an issue and we'll try to help the best we can. Pull Requests and bug fixes are wellcome. 

## Apps using GifCollectionView
If you have an app using GifCollectionView, let me know and I'll link to it here.
