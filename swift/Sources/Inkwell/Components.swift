import SwiftUI

// MARK: - Type

/// Small uppercase label above a section, e.g. "YOUR STATS".
public struct Eyebrow: View {
    public var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text.uppercased())
            .font(Theme.label)
            .tracking(1.4)
            .foregroundStyle(Theme.muted)
    }
}

/// "Plain words, *italic accent*" serif headline.
public struct Headline: View {
    public var plain: String
    public var accent: String
    public var size: CGFloat
    public init(_ plain: String, accent: String = "", size: CGFloat = 38) {
        self.plain = plain; self.accent = accent; self.size = size
    }
    public var body: some View {
        Text("\(Text(plain).font(Theme.display(size)))\(Text(accent).font(Theme.displayItalic(size)))")
            .foregroundStyle(Theme.ink)
            .lineSpacing(2)
    }
}

// MARK: - Surfaces

public struct Card<Content: View>: View {
    public var padding: CGFloat
    public var content: Content
    public init(padding: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.padding = padding; self.content = content()
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 14) { content }
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Theme.line))
    }
}

/// A titled card used for settings-style groups. Fill it with `Row`s.
public struct Panel<Content: View>: View {
    public var title: String
    public var subtitle: String?
    public var content: Content
    public init(_ title: String, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title; self.subtitle = subtitle; self.content = content()
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(Theme.display(21)).foregroundStyle(Theme.ink)
                if let subtitle {
                    Text(subtitle).font(Theme.body).foregroundStyle(Theme.muted)
                }
            }
            Card(padding: 0) {
                VStack(spacing: 0) { content }
            }
        }
    }
}

/// One row inside a Panel, with a hairline divider below.
public struct Row<Trailing: View>: View {
    public var title: String
    public var detail: String?
    public var showsDivider: Bool
    public var trailing: Trailing
    public init(_ title: String, detail: String? = nil, showsDivider: Bool = true,
                @ViewBuilder trailing: () -> Trailing) {
        self.title = title; self.detail = detail; self.showsDivider = showsDivider; self.trailing = trailing()
    }
    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 13.5, weight: .medium)).foregroundStyle(Theme.ink)
                    if let detail {
                        Text(detail).font(.system(size: 12)).foregroundStyle(Theme.muted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Spacer(minLength: 12)
                trailing
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 13)
            if showsDivider { Rectangle().fill(Theme.line).frame(height: 1).padding(.leading, 18) }
        }
    }
}

// MARK: - Buttons

/// Compact solid pill for row actions (Allow, Connect, Download…).
public struct PrimaryButtonStyle: ButtonStyle {
    public var tint: Color
    public init(tint: Color = Theme.ink) { self.tint = tint }
    public func makeBody(configuration: Configuration) -> some View {
        PrimaryPill(configuration: configuration, tint: tint)
    }

    private struct PrimaryPill: View {
        let configuration: ButtonStyle.Configuration
        let tint: Color
        @Environment(\.isEnabled) private var isEnabled
        @State private var hovering = false

        var body: some View {
            configuration.label
                .font(.system(size: 12.5, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .frame(minHeight: 28)
                .background(tint.opacity(configuration.isPressed ? 0.7 : hovering ? 0.85 : 1), in: Capsule())
                .opacity(isEnabled ? 1 : 0.35)
                .contentShape(Capsule())
                .onHover { hovering = $0 }
                .animation(.easeOut(duration: 0.12), value: hovering)
        }
    }
}

/// Dark filled button for the most important action on a screen.
public struct InkButtonStyle: ButtonStyle {
    public var fill: Color
    public init(fill: Color = Theme.ink) { self.fill = fill }
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(fill.opacity(configuration.isPressed ? 0.8 : 1), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .contentShape(Rectangle())
    }
}

/// Quiet outlined button.
public struct GhostButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12.5, weight: .medium))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(configuration.isPressed ? Theme.sidebar : Color.clear, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).strokeBorder(Theme.line))
            .contentShape(Rectangle())
    }
}

/// Icon-only button for list rows.
public struct IconButtonStyle: ButtonStyle {
    public init() {}
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12))
            .foregroundStyle(Theme.muted)
            .frame(width: 26, height: 26)
            .background(configuration.isPressed ? Theme.line : Theme.sidebar.opacity(0.6), in: Circle())
            .contentShape(Circle())
    }
}

public extension ButtonStyle where Self == PrimaryButtonStyle { static var primary: PrimaryButtonStyle { .init() } }
public extension ButtonStyle where Self == InkButtonStyle { static var ink: InkButtonStyle { .init() } }
public extension ButtonStyle where Self == GhostButtonStyle { static var ghost: GhostButtonStyle { .init() } }
public extension ButtonStyle where Self == IconButtonStyle { static var icon: IconButtonStyle { .init() } }

// MARK: - Controls

/// Pill-shaped segmented control.
public struct PillTabs<Value: Hashable>: View {
    public var options: [(Value, String)]
    @Binding public var selection: Value
    public init(_ options: [(Value, String)], selection: Binding<Value>) {
        self.options = options; self._selection = selection
    }
    public var body: some View {
        HStack(spacing: 2) {
            ForEach(options, id: \.0) { value, label in
                Button { selection = value } label: {
                    Text(label)
                        .font(.system(size: 12.5, weight: .medium))
                        .foregroundStyle(selection == value ? Theme.ink : Theme.muted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selection == value ? Theme.card : .clear, in: Capsule())
                        .overlay(Capsule().strokeBorder(selection == value ? Theme.line : .clear))
                        .contentShape(Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(3)
        .background(Theme.sidebar, in: Capsule())
    }
}

/// A key cap, e.g. "⌥ Right Option".
public struct KeyCap: View {
    public var text: String
    public init(_ text: String) { self.text = text }
    public var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .rounded))
            .foregroundStyle(Theme.ink)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 6))
            .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(Theme.ink.opacity(0.25)))
            .shadow(color: Theme.ink.opacity(0.12), radius: 0, y: 1.5)
    }
}

/// Filled check when OK, outlined exclamation when not.
public struct StatusDot: View {
    public var ok: Bool
    public init(ok: Bool) { self.ok = ok }
    public var body: some View {
        Image(systemName: ok ? "checkmark" : "exclamationmark")
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(ok ? Color.white : Theme.ink)
            .frame(width: 22, height: 22)
            .background(ok ? Theme.ink : Theme.card, in: Circle())
            .overlay(Circle().strokeBorder(Theme.ink, lineWidth: ok ? 0 : 1.2))
    }
}

public struct SearchField: View {
    @Binding public var text: String
    public var prompt: String
    public init(text: Binding<String>, prompt: String) { self._text = text; self.prompt = prompt }
    public var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass").foregroundStyle(Theme.faint)
            TextField(prompt, text: $text).textFieldStyle(.plain)
            if !text.isEmpty {
                Button { text = "" } label: { Image(systemName: "xmark.circle.fill") }
                    .buttonStyle(.plain).foregroundStyle(Theme.faint)
            }
        }
        .font(Theme.body)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 9))
        .overlay(RoundedRectangle(cornerRadius: 9).strokeBorder(Theme.line))
    }
}

/// Outlined text input matching the theme.
public struct ThemedField: View {
    public var placeholder: String
    @Binding public var text: String
    public var axis: Axis
    public init(_ placeholder: String, text: Binding<String>, axis: Axis = .horizontal) {
        self.placeholder = placeholder; self._text = text; self.axis = axis
    }
    public var body: some View {
        TextField(placeholder, text: $text, axis: axis)
            .textFieldStyle(.plain)
            .font(Theme.body)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Theme.paper, in: RoundedRectangle(cornerRadius: 9))
            .overlay(RoundedRectangle(cornerRadius: 9).strokeBorder(Theme.line))
    }
}

public extension View {
    /// Standard scrolling page: paper background, generous margins, readable width.
    func page() -> some View {
        ScrollView {
            self
                .padding(.horizontal, 44)
                .padding(.top, 36)
                .padding(.bottom, 48)
                .frame(maxWidth: 860, alignment: .leading)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .scrollContentBackground(.hidden)
        .background(Theme.paper)
    }
}
