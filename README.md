
GzipSwift
========================

[![platform](https://img.shields.io/badge/platform-macOS%20|%20iOS%20|%20watchOS%20|%20tvOS%20|%20Linux-blue.svg)]()
[![CI Status](https://github.com/1024jp/GzipSwift/workflows/CI/badge.svg)](https://github.com/1024jp/GzipSwift/actions)
[![Carthage-compatible](https://img.shields.io/badge/Carthage-✔-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SwiftPM-compatible](https://img.shields.io/badge/SwiftPM-✔-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![CocoaPods-compatible](http://img.shields.io/cocoapods/v/GzipSwift.svg?style=flat)](https://cocoapods.org/pods/GzipSwift)

__GzipSwift__ is a framework with an extension of Data written in Swift. It enables compress/decompress gzip using zlib.

- __Requirements__: OS X 10.9 / iOS 8 / watchOS 2 / tvOS 9 or later
- __Swift version__: Swift 5.0, 5.1


## Usage

```swift
import Gzip

// gzip
let compressedData: Data = try! data.gzipped()
let optimizedData: Data = try! data.gzipped(level: .bestCompression)

// gunzip
let decompressedData: Data
if data.isGzipped {
    decompressedData = try! data.gunzipped()
} else {
    decompressedData = data
}
```


## Installation

### Swift Package Manager

GzipSwift is SwiftPM-compatible. To install, add this package to your `Package.swift` or your Xcode project.

#### For Linux

1. Install zlib if you haven't installed yet:

    ```bash
    $ apt-get install zlib-dev
    ```
2. Add this package to your package.swift.
3. If Swift build failed with a linker error:
    * check if libz.so is in your /usr/local/lib
        * if no, reinstall zlib as step (1)
        * if yes, link the library manually by passing '-Xlinker -L/usr/local/lib' with `swift build`

### Carthage
GzipSwift is [Carthage](https://github.com/Carthage/Carthage)-compatible. To install, add the following line to your `Cartfile`:

```ruby
github "1024jp/GzipSwift"
```

### CocoaPods
GzipSwift is available through [CocoaPods](http://cocoapods.org). To install, add the following line to your `Podfile`:

```ruby
pod 'GzipSwift'
```

### Manual Installation

1. Open Gzip.xcodeproj on Xcode and build Gzip framework for your target platform.
2. Append the built `Gzip.framework` to your project.
3. Go to __General__ pane of the application target in your project. Add `Gzip.framework` to the __Embedded Binaries__ section.
    <br /><img src="Documentation/EmbeddedBinaries@2x.png" height="135"/>


## License

© 2014-2019 1024jp

GzipSwift is distributed under the terms of the __MIT License__. See [LICENSE](LICENSE) for details.
