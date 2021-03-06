fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
### build_for_testing
```
fastlane build_for_testing
```
Generate .xcconfig, install pods, clean build for testing and notify discord
### run_all_tests
```
fastlane run_all_tests
```
Run app tests
### build_and_test
```
fastlane build_and_test
```
Build for testing and run all tests
### discord_notify
```
fastlane discord_notify
```
Send notification to discord
### generate_config
```
fastlane generate_config
```
Generate .xcconfig file

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
