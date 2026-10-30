import Defaults
import KeyboardShortcuts
import SwiftUI

struct ListHeaderView: View {
  @FocusState.Binding var searchFocused: Bool
  @Binding var searchQuery: String

  @Environment(AppState.self) private var appState
  @Environment(\.scenePhase) private var scenePhase

  @Default(.showTitle) private var showTitle
  @Default(.keepWindowOnTop) private var keepWindowOnTop

  private var windowPinAction: LocalizedStringKey {
    keepWindowOnTop ? "window_unpin_action" : "window_pin_action"
  }

  var body: some View {
    HStack {
      ToolbarButton {
        keepWindowOnTop.toggle()
      } label: {
        Image(systemName: keepWindowOnTop ? "pin.fill" : "pin")
          .foregroundStyle(keepWindowOnTop ? Color.accentColor : Color.secondary)
          .frame(width: 23)
      }
      .focusable(false)
      .help(Text(windowPinAction))
      .accessibilityLabel(Text(windowPinAction))
      .accessibilityAddTraits(keepWindowOnTop ? [.isSelected] : [])
      .accessibilityIdentifier("keep-window-on-top")

      if showTitle {
        Text("Maccy")
          .foregroundStyle(.secondary)
          .padding(.leading, 5)
      }

      SearchFieldView(placeholder: "search_placeholder", query: $searchQuery)
        .focused($searchFocused)
        .frame(maxWidth: .infinity)
        .onChange(of: scenePhase) {
          if scenePhase == .background && !searchQuery.isEmpty {
            searchQuery = ""
          }
        }
        // Only reliable way to disable the cursor. allowsHitTesting() does not work
        .offset(y: appState.searchVisible ? 0 : -Popup.itemHeight)
    }
  }
}
