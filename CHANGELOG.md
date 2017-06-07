
Change Log
==========================

4.0.0-beta
--------------------------

### Changes

- Update project for Xcode 9.



3.1.4
--------------------------

### Fixes

- Fix a possible error on watchOS and tvOS.



3.1.3
--------------------------

### Changes

- Update Xcode to 8.2.



3.1.2
--------------------------

### New

- Support CocoaPods.



3.1.1
--------------------------

### Fixes

- Fix the Swift Package Manager support.



3.1.0
--------------------------

### New

- Support the Swift Package Manager.



3.0.1
--------------------------

### Changes

- Update Swift to 3.0.1.



3.0.0
--------------------------

### Changes

- Migrate code to Swift 3.0
- Become framework.
- Support watchOS and tvOS
- Rename from "NSData+GZIP" to "Data+Gzip"
- Add `level` option to `gzipped()` method.
- Add `isGzipped` property (readonly).



2.0.0
--------------------------

### Changes

- Migrate code to Swift 2.0
- Change to throw error instead returning `nil`.
- Use Modulemap for zlib instead of `Bridging-Header.h` (see README for how to install).



1.1.0
--------------------------

### Changes

- Change to return just an empty NSData instead of nil if given data is empty
- Log error message if compression/decompression is failed.
    - [Note] This is a temporaly improvement.
      I'll migrate functions to throw NSError when Swift 2.0 becomes stable. -> Done.
