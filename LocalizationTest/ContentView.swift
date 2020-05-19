//
//  ContentView.swift
import SwiftUI

struct ContentView: View {
    class Model {
        let name: String = "Bob"
        let age: Int = 42
    }

    let model = Model()

    @Environment(\.locale) var locale

    var body: some View {
        VStack {
            Text("Locale: \(locale.languageCode ?? "unknown")")
            Group {
                // Works fine
                Text(L10n.ContentView.sampleMessage)

                // Lookup works, but doesn't understand environment properties, always uses default locale
                Text(NSLocalizedString("Some sample message", comment: ""))

                // Works, also uses environment properties, but doesn't work in preview (yet?)
                Text(L10n.ContentView.nameAge(model.name, model.age))

                // Works, uses Text directly, so a different table (and bundle) can be specified
                Button(action: {}, label: { L10n.ContentView.buttonOne(model.name) })

                // Works, wraps result in a struct containing needed info, so the implementation has the freedom to choose how to use the string
                Button(action: {}, label: { Text(L10n.ContentView.buttonTwo(model.name)) })

            }.font(.footnote)

        }.padding()
            .background(Color("background")).padding(1)
            .background(Color("border")).padding()
    }
}

// Note: in the preview this is broken, running in a simulator or on device does work
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()

            ContentView().environment(\.locale, Locale(identifier: "en"))

            ContentView().environment(\.locale, Locale(identifier: "nl-NL"))
        }
    }
}

// Let's pretent this is generated!
struct L10n {
    struct ContentView {
        // Does't work unless explicitly specifying the type 'LocalizedStringKey'
        static let sampleMessage: LocalizedStringKey = "Some sample message"

        static func nameAge(_ s1: String, _ i2: Int) -> LocalizedStringKey {
            "ContentView.nameAge \(s1) \(i2)"
        }

        static func buttonOne(_ s1: String) -> Text {
            Text("ContentView.button \(s1)", tableName: "Another", bundle: Bundle(for: BundleToken.self))
        }

        static func buttonTwo(_ s1: String) -> LocalizedStringSet {
            LocalizedStringSet(key: "ContentView.button \(s1)", tableName: "Another", bundle: Bundle(for: BundleToken.self))
        }
    }

    struct LocalizedStringSet {
        let key: LocalizedStringKey
        let tableName: String?
        let bundle: Bundle?

        var asText: Text {
            Text(key, tableName: tableName, bundle: bundle)
        }
    }
}

// Initializer to use LocalizedStringSet
extension Text {
    init(_ set: L10n.LocalizedStringSet) {
        self.init(set.key, tableName: set.tableName, bundle: set.bundle)
    }
}

private class BundleToken {}
