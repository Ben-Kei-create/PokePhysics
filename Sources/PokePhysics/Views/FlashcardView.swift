import SwiftUI

// MARK: - Tab root

struct FlashcardView: View {
    @EnvironmentObject private var bookmarkStore: BookmarkStore

    @State private var phase: Phase = .setup
    @State private var selectedCategoryID: UUID? = nil
    @State private var bookmarkedOnly = false
    @State private var cards: [Formula] = []
    @State private var currentIndex = 0
    @State private var isFlipped = false
    @State private var reviewQueue: [Formula] = []

    private let categories = FormulaLibrary.allCategories

    enum Phase { case setup, session, results }

    private var candidateFormulas: [Formula] {
        let pool: [FormulaCategory]
        if let id = selectedCategoryID, let cat = categories.first(where: { $0.id == id }) {
            pool = [cat]
        } else {
            pool = categories
        }
        let all = pool.flatMap(\.formulas)
        return bookmarkedOnly ? all.filter { bookmarkStore.isBookmarked($0) } : all
    }

    var body: some View {
        switch phase {
        case .setup:   setupView
        case .session: sessionView
        case .results: resultsView
        }
    }

    // MARK: - Setup

    private var setupView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("暗記モード")
                        .font(.largeTitle).fontWeight(.bold)
                    Text("カテゴリを選んでスタート")
                        .font(.subheadline).foregroundColor(.secondary)
                }
                .padding(.top, 8)

                // Category selector
                VStack(alignment: .leading, spacing: 10) {
                    sectionLabel("カテゴリ")
                    CategoryButton(title: "すべて", icon: "square.stack",
                                   count: categories.flatMap(\.formulas).count,
                                   isSelected: selectedCategoryID == nil) {
                        selectedCategoryID = nil
                    }
                    ForEach(categories) { cat in
                        CategoryButton(title: cat.name, icon: cat.icon,
                                       count: cat.formulas.count,
                                       isSelected: selectedCategoryID == cat.id) {
                            selectedCategoryID = cat.id
                        }
                    }
                }

                // Bookmarked filter
                VStack(alignment: .leading, spacing: 10) {
                    sectionLabel("フィルター")
                    Toggle(isOn: $bookmarkedOnly) {
                        Label("ブックマークのみ", systemImage: "bookmark.fill")
                            .foregroundColor(.primary)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .navyAccent))
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.cardBackground))
                }

                // Card count + start button
                let count = candidateFormulas.count
                VStack(spacing: 14) {
                    Text("\(count) 枚")
                        .font(.title2).fontWeight(.bold)
                        .foregroundColor(count == 0 ? .secondary : .navyAccent)

                    Button { startSession() } label: {
                        Text("スタート")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(count == 0 ? Color.secondary : Color.navyButton)
                            )
                    }
                    .disabled(count == 0)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    @ViewBuilder
    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.caption).fontWeight(.semibold)
            .foregroundColor(.secondary)
            .textCase(.uppercase).tracking(0.5)
    }

    private func startSession() {
        cards = candidateFormulas.shuffled()
        currentIndex = 0
        isFlipped = false
        reviewQueue = []
        phase = .session
    }

    // MARK: - Session

    private var sessionView: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                HStack {
                    Text("\(min(currentIndex + 1, cards.count)) / \(cards.count)")
                        .font(.subheadline).fontWeight(.semibold)
                        .foregroundColor(.navyAccent)
                    Spacer()
                    Button("終了") { phase = .results }
                        .font(.subheadline).foregroundColor(.secondary)
                }
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.navyAccent.opacity(0.12))
                        Capsule().fill(Color.navyAccent)
                            .frame(width: geo.size.width * CGFloat(currentIndex) / CGFloat(max(cards.count, 1)))
                            .animation(.spring(), value: currentIndex)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Spacer()

            if currentIndex < cards.count {
                let formula = cards[currentIndex]

                FlipCard(formula: formula, isFlipped: isFlipped)
                    .padding(.horizontal, 20)
                    .id(formula.id)
                    .onTapGesture {
                        guard !isFlipped else { return }
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isFlipped = true
                        }
                    }

                if !isFlipped {
                    Text("タップして数式を見る")
                        .font(.caption).foregroundColor(.secondary)
                        .padding(.top, 16)
                        .transition(.opacity)
                } else {
                    HStack(spacing: 16) {
                        ActionButton(title: "もう一度", icon: "arrow.counterclockwise", color: .orange) {
                            reviewQueue.append(cards[currentIndex])
                            advance()
                        }
                        ActionButton(title: "覚えた", icon: "checkmark", color: .teal) {
                            advance()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }

            Spacer()
        }
        .background(Color.appBackground.ignoresSafeArea())
    }

    private func advance() {
        withAnimation(.easeOut(duration: 0.15)) { isFlipped = false }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeInOut(duration: 0.2)) {
                currentIndex += 1
                if currentIndex >= cards.count { phase = .results }
            }
        }
    }

    // MARK: - Results

    private var resultsView: some View {
        let total = cards.count
        let missed = reviewQueue.count
        let remembered = total - missed

        return VStack(spacing: 0) {
            Spacer()

            // Score
            VStack(spacing: 20) {
                Text(remembered == total ? "完璧！" : remembered > total / 2 ? "いい感じ" : "まだまだ")
                    .font(.system(.title3, design: .rounded))
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)

                VStack(spacing: 4) {
                    Text("\(remembered)")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.navyAccent)
                    Text("/ \(total) 枚 覚えた")
                        .font(.title3).foregroundColor(.secondary)
                }

                // Bar
                VStack(spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.navyAccent.opacity(0.12)).frame(height: 10)
                            Capsule().fill(Color.teal)
                                .frame(width: total > 0 ? geo.size.width * CGFloat(remembered) / CGFloat(total) : 0,
                                       height: 10)
                        }
                    }
                    .frame(height: 10)
                    HStack {
                        Label("\(remembered) 覚えた", systemImage: "checkmark")
                            .font(.caption).foregroundColor(.teal)
                        Spacer()
                        if missed > 0 {
                            Label("\(missed) もう一度", systemImage: "arrow.counterclockwise")
                                .font(.caption).foregroundColor(.orange)
                        }
                    }
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            // Buttons
            VStack(spacing: 12) {
                if missed > 0 {
                    Button {
                        cards = reviewQueue.shuffled()
                        currentIndex = 0; isFlipped = false; reviewQueue = []
                        phase = .session
                    } label: {
                        Label("間違えた \(missed) 枚をもう一度", systemImage: "arrow.counterclockwise")
                            .font(.headline).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 16)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.orange))
                    }
                    .buttonStyle(.plain)
                }

                Button { startSession() } label: {
                    Text("最初からやり直す")
                        .font(.headline).foregroundColor(.navyAccent)
                        .frame(maxWidth: .infinity).padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.navyAccent.opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.navyAccent.opacity(0.25), lineWidth: 1))
                        )
                }
                .buttonStyle(.plain)

                Button { phase = .setup } label: {
                    Text("カテゴリ選択に戻る")
                        .font(.subheadline).foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 48)
        }
        .background(Color.appBackground.ignoresSafeArea())
    }
}

// MARK: - Category Button

private struct CategoryButton: View {
    let title: String
    let icon: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(isSelected ? .white : .navyAccent)
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .primary)
                Spacer()
                Text("\(count)枚")
                    .font(.caption)
                    .foregroundColor(isSelected ? .white.opacity(0.75) : .secondary)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.navyButton : Color.cardBackground)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Action Button

private struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 13, weight: .semibold))
                Text(title).font(.headline)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(color.opacity(0.1))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.3), lineWidth: 1))
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Flip Card

private struct FlipCard: View {
    let formula: Formula
    let isFlipped: Bool
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            if isFlipped {
                BackFace(formula: formula, scheme: scheme)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.96).combined(with: .opacity),
                        removal:   .scale(scale: 0.96).combined(with: .opacity)
                    ))
            } else {
                FrontFace(formula: formula)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.96).combined(with: .opacity),
                        removal:   .scale(scale: 0.96).combined(with: .opacity)
                    ))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }
}

private struct FrontFace: View {
    let formula: Formula

    var body: some View {
        VStack(spacing: 16) {
            Text("?")
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .foregroundColor(.navyAccent.opacity(0.25))

            Text(formula.title)
                .font(.title2).fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)

            if !formula.subcategory.isEmpty {
                Text(formula.subcategory)
                    .font(.caption).foregroundColor(.secondary)
                    .padding(.horizontal, 12).padding(.vertical, 4)
                    .background(Capsule().fill(Color.navyAccent.opacity(0.1)))
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.cardBackground)
                .shadow(color: Color.navyButton.opacity(0.1), radius: 16, x: 0, y: 6)
        )
    }
}

private struct BackFace: View {
    let formula: Formula
    let scheme: ColorScheme

    var body: some View {
        VStack(spacing: 18) {
            LaTeXView(
                latex: formula.latex,
                fontSize: 34,
                textColor: scheme == .dark ? .white : .black
            )
            .frame(maxWidth: .infinity)
            .frame(height: 64)

            Divider()

            Text(formula.summary)
                .font(.subheadline).foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.cardBackground)
                .shadow(color: Color.navyButton.opacity(0.1), radius: 16, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.navyAccent.opacity(0.2), lineWidth: 1.5)
                )
        )
    }
}
