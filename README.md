
NSData+GZIP.swift
========================

[![Build Status](http://img.shields.io/travis/1024jp/NSData-GZIP/master.svg?style=flat)](https://travis-ci.org/1024jp/NSData-GZIP)

__NSData+GZIP.swift__ is an extension of NSData written in Swift 2.0. It enables compress/decompress gzip using zlib.

- __Requirements__: OS X 10.9 / iOS 7 or later


## Usage

```swift
// gzip
let compressedData : NSData = data.gzippedData()

// gunzip
let decompressedData : NSData = compressedData.gunzippedData()
```

```objc
#import "ProjectName-Swift.h"

// gzip
NSData *compressedData = [data gzippedData];

// gunzip
NSData *decompressedData = [compressedData gunzippedData];
```


## Installation

1. Add `NSData+GZIP.swift` file to your project.
2. Add `libz.tbd` library to your project.
3. Add a line `#include <zlib.h>` to your ProjectName-Bridging-Header.h file.
4. Invoke from your Swift/ObjC files.


## Lisence

© 2014-2015 1024jp

NSData+GZIP.swift is distributed under the terms of the __MIT License__. See [LISENCE](LISENCE) for details.