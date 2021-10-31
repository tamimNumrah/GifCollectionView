# GifCollectionView
![CocoaPods](https://img.shields.io/cocoapods/v/GifCollectionView.svg)

Drop in Gif Collection View. Uses Tenor as GIFs provider. 

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

```swift
gifCollectionView = GifCollectionView.init()
gifCollectionView.delegate = self
view.addSubview(gifCollectionView)
```
Load Gifs using Tenor

```swift
gifCollectionView.setTenorApiKey(apiKey: "YOUR_TENOR_API_KEY")
gifCollectionView.startLoadingGifs()
```

Or you can supply your own Gifs provider by conforming to GifProvider protocol

```swift
gifCollectionView.replaceProvider(<#T##provider: GifProvider##GifProvider#>)
gifCollectionView.startLoadingGifs()
```
