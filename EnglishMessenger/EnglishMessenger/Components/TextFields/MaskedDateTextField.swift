//
//  MaskedDateTextField.swift
//  EnglishMessenger
//
//  Created by Данила on 02.03.2024.
//

import SwiftUI
import Combine

struct MaskedDateTextField: View {
    @Binding var text: String

    let dateFormatter: DateFormatter

    init(text: Binding<String>, dateFormat: String = "dd.mm.yyyy") {
        self._text = text
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = dateFormat
    }

    var body: some View {
        CustomTextField(textFieldLabel: "dd.mm.yyyy", text: $text)
            .onChange(of: text) { newValue in
                if let date = dateFormatter.date(from: newValue) {
                    text = dateFormatter.string(from: date)
                }
            }
            .onReceive(Just(text)) { newValue in
                let filtered = newValue.filter { "0123456789".contains($0) }
                var formattedText = ""
                for (index, char) in filtered.enumerated() {
                    if index == 2 || index == 4 {
                        formattedText += "."
                    }
                    formattedText += String(char)
                }
                text = formattedText.prefix(10).description
            }
    }
}
