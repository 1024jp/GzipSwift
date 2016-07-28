
GzipSwift
========================

[![macOS](https://img.shields.io/badge/macOS-10.9%2B-blue.svg)]()
[![iOS](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)]()
[![Swift](https://img.shields.io/badge/Swift-3.0-blue.svg)]()
[![Carthage compatible](https://img.shields.io/badge/Carthage-✓-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://img.shields.io/travis/1024jp/NSData-GZIP/master.svg?style=flat)](https://travis-ci.org/1024jp/NSData-GZIP)
[![License](https://img.shields.io/github/license/1024jp/NSData-GZIP.svg)](https://github.com/1024jp/NSData-GZIP/blob/develop/LICENSE)

__GzipSwift__ is an extension of Data written in Swift 3.0. It enables compress/decompress gzip using zlib.

- __Requirements__: OS X 10.9 / iOS 8 or later


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

// check data is gzipped
print(compressedData.isGgipped)
```


## Installation

1. Build Gzip framework.
3. In *Build Phases*, add `Gzip.framework` library to your project.
    <img src="Documentation/binary_link@2x.png" height="150"/>
5. `import Gzip` in your Swift file.
6. Use in your code.


## Lisence

© 2014-2016 1024jp

GzipSwift is distributed under the terms of the __MIT License__. See [LISENCE](LISENCE) for details.
