import Foundation

enum AdMobConfiguration {
    static let appID = "ca-app-pub-4859622277330192~3987394778"

    #if DEBUG
    static let formulaBannerAdUnitID = "ca-app-pub-3940256099942544/2435281174"
    #else
    static let formulaBannerAdUnitID = "ca-app-pub-4859622277330192/6292474002"
    #endif
}
