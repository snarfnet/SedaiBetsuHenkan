import GoogleMobileAds

@MainActor
class InterstitialAdManager: NSObject, ObservableObject {
    private var interstitial: GADInterstitialAd?
    private var convertCount = 0
    private let showEvery = 5

    func countConvert() {
        convertCount += 1
        if convertCount >= showEvery {
            convertCount = 0
            showAd()
        }
    }

    func loadAd() {
        GADInterstitialAd.load(
            withAdUnitID: "ca-app-pub-9404799280370656/7344238788",
            request: GADRequest()
        ) { [weak self] ad, error in
            if let error {
                print("Interstitial load error: \(error.localizedDescription)")
                return
            }
            self?.interstitial = ad
        }
    }

    private func showAd() {
        guard let interstitial,
              let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let root = windowScene.windows.first?.rootViewController else {
            loadAd()
            return
        }
        interstitial.present(fromRootViewController: root)
        loadAd()
    }
}
