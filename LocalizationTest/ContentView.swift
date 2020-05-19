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

                // Works, uses Text directly, so a different table (and bundle) can be specified)
                Button(action: {}, label: { L10n.ContentView.Button(model.name) })

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

        static func Button(_ s1: String) -> Text {
            Text("ContentView.button \(s1)", tableName: "Another", bundle: Bundle(for: BundleToken.self))
        }
    }
}

private class BundleToken {}
