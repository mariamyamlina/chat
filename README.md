# Chat

[![Build Status](https://travis-ci.org/mariamyamlina/chat.svg?branch=homework-13)](https://travis-ci.org/mariamyamlina/chat)

## Description

- Chat project for TFS

## Pre-install

1. Execute the following command before start to install the encryption library:
   ```
   $brew install libsodium
   ```
2. To generate *Config.xcconfig* file two options can be used.
   * Automatically by executing the following.
      ``` 
      $bundle exec fastlane generate_config
      ```
   * Manually by adding to *Config.xcconfig* file the following content, where the values should be changed to API keys received on [Pixabay](https://pixabay.com/) and [Firebase](https://firebase.google.com/) respectively.
      ``` 
      NETWORK_API_KEY = <value>
      FB_API_KEY = <value>
      ```

## Author

- **Maria Myamlina** mariamyamlina@gmail.com
