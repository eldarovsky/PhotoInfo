<h1>PhotoInfo</h1>

<p><strong>DESCRIPTION:</strong> an application for viewing metadata and the location on the map where the photo was taken, if data is available. You can select an image from the phone's photo gallery or download it by URL.</p>
<p><strong>DETAILS:</strong> UIKit, MVP-C, CocoaPods: <a href="https://yandex.ru/dev/mapkit/doc/en/ios/generated/getting_started">Yandex MapKit</a>, <a href="https://github.com/realm/SwiftLint">SwiftLint</a></p>
<details>
<summary><strong>INSTALLATION</strong></summary>

1. **Get the Yandex MapKit API key:**
    
    - Go to the [Developer Dashboard](https://developer.tech.yandex.ru/services/).
    - **Log in** to your Yandex account or **create** a new one.
    - Click **Connect APIs** and choose **MapKit Mobile SDK**.
    - Enter information about yourself and your project, select a pricing plan, and click **Continue**.
    - After your API key is successfully created, it will be available in the **API Interfaces → MapKit Mobile SDK** tab.
      
```sh
NOTE: It takes about 15 minutes to activate API keys.
```

2. **Clone this repository to your local machine:**

```sh
https://github.com/eldarovsky/PhotoInfo.git
```

3. **Install pods dependencies:**

- open `PhotoInfo` folder in Terminal
- enter `pod install`
    
4. **Open the project in Xcode:**

    - Launch Xcode.
    - Select **Open** from the File menu.
    - Navigate to the project folder and select the `.xcworkspace` file.

5. **Enter API key:**

    - Go to the `AppDelegate` file and replace `enter_API_key` text with your API key.
    
6. **Check Build Options:**

    - Check `PhotoInfo` and `Pods` -> PROJECT and all TARGETS -> Build Settings -> Build Options: `User Script Sandboxing: No`
    
7. **Build and Run the Project:**

   - Click the **Run** button (▶) in Xcode's toolbar.
   - The app will build and launch in the selected simulator or device.

</details>

<p><strong>SCREENSHOTS:</p>
    
![1](https://github.com/eldarovsky/PhotoInfo/assets/60284515/b083ba08-c31b-42c8-aa51-f1ec3ea7fd88)
![2](https://github.com/eldarovsky/PhotoInfo/assets/60284515/92fcddae-f9c0-45bd-b613-faf10be9631c)
