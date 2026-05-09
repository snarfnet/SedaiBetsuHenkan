import SwiftUI

private let kBannerAdID = "ca-app-pub-9404799280370656/5530418067"

struct ContentView: View {
    @State private var inputText = ""
    @State private var outputText = ""
    @State private var selectedStyle: GenerationStyle = .gal
    @State private var showCopied = false
    @StateObject private var interstitialManager = InterstitialAdManager()

    var body: some View {
        VStack(spacing: 0) {
            NavigationStack {
                ZStack {
                    Palette.bg.ignoresSafeArea()
                    TimelineBackdrop()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)

                    ScrollView {
                        VStack(spacing: 18) {
                            hero
                            inputSection
                            styleSelector
                            convertButton
                            outputSection
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                        .padding(.bottom, 22)
                    }
                    .scrollIndicators(.hidden)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Palette.bg.opacity(0.9), for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        HStack(spacing: 8) {
                            Image(systemName: "quote.bubble.fill")
                                .font(.system(size: 15, weight: .black))
                                .foregroundStyle(Palette.yellow)
                            Text("世代別変換")
                                .font(.system(size: 17, weight: .black, design: .rounded))
                                .foregroundStyle(Palette.text)
                        }
                    }
                }
            }

            BannerAdView(adUnitID: kBannerAdID)
                .frame(height: 50)
                .background(Color.black)
        }
        .task {
            interstitialManager.loadAd()
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("GENERATION TRANSLATOR")
                        .font(.system(size: 11, weight: .heavy, design: .rounded))
                        .tracking(1.1)
                        .foregroundStyle(Palette.cyan)
                    Text("言葉の時代を\nスイッチ")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(Palette.text)
                        .lineSpacing(2)
                }
                Spacer(minLength: 12)
                VStack(spacing: 5) {
                    Text(selectedStyle.shortName)
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .foregroundStyle(Palette.ink)
                    Text("MODE")
                        .font(.system(size: 10, weight: .black, design: .rounded))
                        .foregroundStyle(Palette.ink.opacity(0.64))
                }
                .frame(width: 76, height: 76)
                .background(Palette.yellow)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Palette.yellow.opacity(0.32), radius: 20, y: 10)
            }

            Text("いつもの文章を、おじさん構文・ギャル語・Z世代・昭和レトロへ一瞬で変換します。")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(Palette.sub)
                .lineSpacing(4)
        }
        .padding(18)
        .background(Palette.glass)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Palette.line, lineWidth: 1)
        )
    }

    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("変換したい文章", icon: "text.cursor")

            ZStack(alignment: .topLeading) {
                TextEditor(text: $inputText)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Palette.text)
                    .frame(minHeight: 132)
                    .padding(8)
                    .scrollContentBackground(.hidden)
                    .background(Palette.card)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Palette.line, lineWidth: 1)
                    )

                if inputText.isEmpty {
                    Text("例：明日の集合時間、少し早めでも大丈夫？")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Palette.sub.opacity(0.62))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 17)
                        .allowsHitTesting(false)
                }
            }

            HStack {
                Label("\(inputText.count)文字", systemImage: "number")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Palette.sub)
                Spacer()
                if !inputText.isEmpty {
                    Button {
                        inputText = ""
                        outputText = ""
                    } label: {
                        Label("クリア", systemImage: "xmark.circle.fill")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundStyle(Palette.pink)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(14)
        .background(Palette.panel)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Palette.line, lineWidth: 1)
        )
    }

    private var styleSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("変換モード", icon: "person.3.fill")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(GenerationStyle.allCases) { style in
                    styleButton(style)
                }
            }
        }
        .padding(14)
        .background(Palette.panel)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Palette.line, lineWidth: 1)
        )
    }

    private func styleButton(_ style: GenerationStyle) -> some View {
        let isSelected = selectedStyle == style
        return Button {
            selectedStyle = style
        } label: {
            VStack(alignment: .leading, spacing: 9) {
                HStack {
                    Image(systemName: style.icon)
                        .font(.system(size: 17, weight: .black))
                        .foregroundStyle(isSelected ? Palette.ink : Palette.cyan)
                        .frame(width: 34, height: 34)
                        .background(isSelected ? Palette.yellow : Palette.soft)
                        .clipShape(Circle())
                    Spacer()
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .black))
                            .foregroundStyle(Palette.yellow)
                    }
                }
                Text(style.rawValue)
                    .font(.system(size: 15, weight: .black, design: .rounded))
                    .foregroundStyle(Palette.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Text(style.sample)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(Palette.sub)
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
            }
            .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
            .padding(12)
            .background(isSelected ? Palette.selectedCard : Palette.card)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? Palette.yellow.opacity(0.88) : Palette.line, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var convertButton: some View {
        Button {
            convert()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 18, weight: .black))
                Text("この世代に変換")
                    .font(.system(size: 17, weight: .black, design: .rounded))
            }
            .foregroundStyle(Palette.ink)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 17)
            .background(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Palette.disabled : Palette.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 19, style: .continuous))
            .shadow(color: Palette.yellow.opacity(inputText.isEmpty ? 0 : 0.28), radius: 18, y: 10)
        }
        .buttonStyle(.plain)
        .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }

    @ViewBuilder
    private var outputSection: some View {
        if outputText.isEmpty {
            previewSection
        } else {
            VStack(alignment: .leading, spacing: 11) {
                HStack {
                    sectionTitle("変換結果", icon: "text.bubble.fill")
                    Spacer()
                    Button {
                        UIPasteboard.general.string = outputText
                        showCopied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            showCopied = false
                        }
                    } label: {
                        Label(showCopied ? "コピー済み" : "コピー", systemImage: showCopied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 12, weight: .black, design: .rounded))
                            .foregroundStyle(showCopied ? Palette.yellow : Palette.cyan)
                    }
                    .buttonStyle(.plain)

                    ShareLink(item: outputText) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 15, weight: .black))
                            .foregroundStyle(Palette.cyan)
                    }
                }

                Text(outputText)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Palette.text)
                    .lineSpacing(6)
                    .textSelection(.enabled)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Palette.result)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Palette.yellow.opacity(0.45), lineWidth: 1)
                    )

                Button {
                    convert()
                } label: {
                    Label("もう一回変換", systemImage: "dice.fill")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .foregroundStyle(Palette.text)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Palette.soft)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .background(Palette.panel)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Palette.line, lineWidth: 1)
            )
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("変換サンプル", icon: "wand.and.stars")
            HStack(alignment: .top, spacing: 10) {
                speechBubble("明日ちょっと遅れます", label: "元の文", color: Palette.soft)
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .black))
                    .foregroundStyle(Palette.yellow)
                    .padding(.top, 24)
                speechBubble(TextConverter.convert("明日ちょっと遅れます", style: selectedStyle), label: selectedStyle.rawValue, color: Palette.result)
            }
        }
        .padding(14)
        .background(Palette.panel)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Palette.line, lineWidth: 1)
        )
    }

    private func speechBubble(_ body: String, label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(label)
                .font(.system(size: 10, weight: .black, design: .rounded))
                .foregroundStyle(Palette.cyan)
            Text(body)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Palette.text)
                .lineLimit(4)
                .minimumScaleFactor(0.74)
        }
        .frame(maxWidth: .infinity, minHeight: 94, alignment: .topLeading)
        .padding(12)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
    }

    private func sectionTitle(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(.system(size: 13, weight: .black, design: .rounded))
            .foregroundStyle(Palette.sub)
    }

    private func convert() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        outputText = TextConverter.convert(inputText, style: selectedStyle)
        interstitialManager.countConvert()
    }
}

private struct TimelineBackdrop: View {
    var body: some View {
        ZStack {
            Image("GeneratedTimelineBackground")
                .resizable()
                .scaledToFill()
            Palette.bg.opacity(0.48)
            LinearGradient(
                colors: [
                    Color.black.opacity(0.12),
                    Color.black.opacity(0.36),
                    Color.black.opacity(0.72)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

enum Palette {
    static let bg = Color(red: 0.04, green: 0.05, blue: 0.09)
    static let ink = Color(red: 0.05, green: 0.04, blue: 0.05)
    static let panel = Color(red: 0.10, green: 0.11, blue: 0.17).opacity(0.92)
    static let card = Color.white.opacity(0.075)
    static let glass = Color.white.opacity(0.09)
    static let soft = Color.white.opacity(0.10)
    static let selectedCard = Color(red: 0.20, green: 0.17, blue: 0.08).opacity(0.90)
    static let result = Color(red: 0.08, green: 0.16, blue: 0.17).opacity(0.96)
    static let text = Color(red: 0.97, green: 0.96, blue: 0.91)
    static let sub = Color(red: 0.70, green: 0.70, blue: 0.77)
    static let cyan = Color(red: 0.18, green: 0.88, blue: 0.94)
    static let yellow = Color(red: 1.0, green: 0.82, blue: 0.18)
    static let pink = Color(red: 1.0, green: 0.36, blue: 0.58)
    static let line = Color.white.opacity(0.12)
    static let disabled = Color.white.opacity(0.20)
}
