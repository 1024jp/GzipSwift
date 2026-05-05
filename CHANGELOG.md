# Change Log

6.2.0 (unreleased)
--------------------------

### New

- Support typed throw.


### Changes

- Update Swift version to 6.3.
- Make `maxWindowBits` a module-level constant.
- Show zlib error messages when `GzipError` is handled as `Error`.
- Improve the error message when decompression cannot make progress.
- Find zlib headers installed outside `/usr/include` on Linux, such as Linuxbrew.


### Fixes

- Fix accessing types with the `Gzip` module prefix, such as `Gzip.CompressionLevel`.
- Avoid a crash when compressing or decompressing data larger than 4 GiB; compression now throws an error instead.



6.1.0 (2024-06-16)
--------------------------

### Changes

- Support Swift 6.0.



6.0.1 (2023-06-16)
--------------------------

### Changes

- Add `Sendable` to `GzipError` and `CompressionLevel`.



6.0.0 (2023-04-29)
--------------------------

### New

- Support decompression for combined compression.
- Add `wBits` optional parameter to `gzipped(level:)` and `.gunzipped()` to support managing the size of the history buffer.


### Changes

- Remove support for CocoaPods and Carthage.
- Update minimum Swift version to 5.4.
- Break immediately when inflate exactly reaches the end of the buffer.



5.2.0 (2022-03-26)
--------------------------

### Changes

- Enable “build library for distribution” flag.



5.1.1 (2019-10-28)
--------------------------

### Fixes

- Fix CocoaPods distribution.



5.1.0 (2019-10-23)
--------------------------

### Fixes

- Fix chunk size.



5.0.0 (2019-04-02)
--------------------------

### Changes

- Update for Swift 5.0


4.1.0 (2019-02-16)
--------------------------

### Changes

- Support Bitcode.
- Update for Swift 4.2.
- Conform GzipError to Equatable.


4.0.4 (2017-11-12)
--------------------------

### Fixes

- Fix CocoaPods distribution.


4.0.3 (2017-11-11)
--------------------------

### Fixes

- Fix running on Linux.
- Fix a runtime crash with Xcode 9.1.


4.0.2 (2017-11-01)
--------------------------

### Fixes

- Fix disabling code coverage support.


4.0.1 (2017-11-01)
--------------------------

### Changes

- Disable code coverage test.


4.0.0 (2017-09-17)
--------------------------

No change since 4.0.0-beta.2.



4.0.0-beta.2 (2017-06-10)
--------------------------

### Changes

- Make `CompressionLevel` struct.
- Make `GzipError` struct.



4.0.0-beta (2017-06-07)
--------------------------

### Changes

- Update project for Xcode 9.



3.1.4 (2017-02-14)
--------------------------

### Fixes

- Fix a possible error on watchOS and tvOS.



3.1.3 (2016-12-14)
--------------------------

### Changes

- Update Xcode to 8.2.



3.1.2 (2016-11-26)
--------------------------

### New

- Support CocoaPods.



3.1.1 (2016-11-10)
--------------------------

### Fixes

- Fix the Swift Package Manager support.



3.1.0 (2016-11-10)
--------------------------

### New

- Support the Swift Package Manager.



3.0.1 (2016-10-28)
--------------------------

### Changes

- Update Swift to 3.0.1.



3.0.0 (2016-09-08)
--------------------------

### Changes

- Migrate code to Swift 3.0
- Become framework.
- Support watchOS and tvOS
- Rename from "NSData+GZIP" to "Data+Gzip"
- Add `level` option to `gzipped()` method.
- Add `isGzipped` property (readonly).



2.0.0 (2015-09-10)
--------------------------

### Changes

- Migrate code to Swift 2.0
- Change to throw error instead returning `nil`.
- Use Modulemap for zlib instead of `Bridging-Header.h` (see README for how to install).



1.1.0 (2015-08-02)
--------------------------

### Changes

- Change to return just an empty NSData instead of nil if given data is empty
- Log error message if compression/decompression is failed.
    - [Note] This is a temporaly improvement.
      I'll migrate functions to throw NSError when Swift 2.0 becomes stable. -> Done.
