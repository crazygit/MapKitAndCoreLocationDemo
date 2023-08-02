#  MapKit & CoreLocation 使用示例 in iOS17, Xcode 15

## 参考资料
- [Configuring your app to use location services](https://developer.apple.com/documentation/corelocation/configuring_your_app_to_use_location_services) 应用配置以获取用户定位信息
- [Adopting live updates in Core Location](https://developer.apple.com/documentation/corelocation/adopting_live_updates_in_core_location) 获取用户定位的实时更新信息示例
- [Supporting live updates in SwiftUI and Mac Catalyst apps](https://developer.apple.com/documentation/corelocation/supporting_live_updates_in_swiftui_and_mac_catalyst_apps) 获取用户定位的实时更新信息
- [Monitoring location changes with Core Location](https://developer.apple.com/documentation/corelocation/monitoring_location_changes_with_core_location) 监听用户到达指定位置或者范围
- [Handling location updates in the background](https://developer.apple.com/documentation/corelocation/handling_location_updates_in_the_background) App在后台运行时，如何更新用户定位信息

## 操作步骤

1. 在项目的`Info.plist`文件中，明确需要获取定位信息的声明
    参考[Choosing the Location Services Authorization to Request](https://developer.apple.com/documentation/bundleresources/information_property_list/protected_resources/choosing_the_location_services_authorization_to_request)，根据需要选择需要使用的定位信息

    一般添加前面两个就足够了

    - Privacy - Location Usage Description
    - Privacy - Location When In Use Usage Description
    - Privacy - Location Always Usage Description
    - Privacy - Location Always and When In Use Usage Description

    * `When In Use`表示App只要在使用就能获取到定位信息，无论App是在前台或是后台运行
    * `Always Usage` 表示App无论是否在使用，也可以获取到定位信息

    > When In Use
    >
    > Your app can use all location services and receive events while the app is in use. In general, iOS apps are considered in use when they're in the foreground or running in the background with the background location usage indicator enabled.

    > Always
    >
    > Your app can use all location services and receive events even if the user is not aware that your app is running. If your app isn’t running, the system launches your app and delivers the event.

2. 如需在后台获取定位，需要配置获取后台的信息

    ![](https://images.crazygit.dev/2023/07/background_location.png)

3. [可选步骤][检查需要使用的定位服务是否可用](https://developer.apple.com/documentation/corelocation/configuring_your_app_to_use_location_services#3384898)

    ```swift
    if (CLLocationManager.headingAvailable()) {
       // Enable the app’s compass features.
    } else {
       // Disable compass features.
    }
    ```

4. [如果App依赖的服务是必须的，没有它App就不能工作，则需要再`Info.plist`文件里声明，这样用户在从AppStore里安装服务的时候，如果它 的设备不支持该服务，就不会搜索到App](https://developer.apple.com/documentation/corelocation/configuring_your_app_to_use_location_services#3384900)
![](https://images.crazygit.dev/2023/07/a.png)

5. 具体实现参考 [LocationsHandler](MapKitAndCoreLocationDemo/LocationsHandler.swiftMapKitAndCoreLocationDemo/LocationsHandler.swift)文件
