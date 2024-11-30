//
//  ColorLabelChooserView.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/11/24.
//


import SwiftUI

struct ColorLabelChooser: View {
    @Binding var selectedColor: ColorLabel

    var body: some View {
        
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 70.0, maximum: 70.0))]) {
            ForEach(ColorLabel.allCases, id: \.self) { color in
                Capsule()
                    .fill(Color[color()])
                    .frame(height: 50)
                    .onTapGesture {
                        withAnimation {
                            selectedColor = color
                        }
                    }
                    .overlay {
                        if selectedColor == color {
                            Image(systemName: "checkmark.circle")
                                .foregroundStyle(Color.white.opacity(0.5))
                                .font(.title)
                                .bold()
                                .transition(.opacity)
                        }
                    }
            }
        }
        .padding()
    }
    
    func colorCircle(_ color: ColorLabel, selected: Bool) -> some View {
            Image(systemName: selected ? "circle.circle.fill" : "circle.fill")
                .contentTransition(.symbolEffect(.replace))
                .foregroundStyle(Color[color()])
                .symbolEffect(.pulse, value: selected)

    }
}

#Preview {
    @Previewable @State var selectedColor: ColorLabel = .red
    ColorLabelChooser(selectedColor: $selectedColor)
}
