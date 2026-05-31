import GoogleMobileAds
import SwiftUI

struct AdBannerView: View {
    let adUnitID: String

    var body: some View {
        GeometryReader { proxy in
            let width = max(proxy.size.width, 320)
            let adSize = largeAnchoredAdaptiveBanner(width: width)

            BannerViewContainer(adUnitID: adUnitID, adSize: adSize)
                .frame(width: adSize.size.width, height: adSize.size.height)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(height: 64)
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    let adUnitID: String
    let adSize: AdSize

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        guard uiView.adSize.size != adSize.size else { return }
        uiView.adSize = adSize
        uiView.load(Request())
    }
}
