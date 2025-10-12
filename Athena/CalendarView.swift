//
//  CalendarView.swift
//  Athena
//
//  Created by A.I. and Tonia Sanzo on 10/9/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var selectedDate: Date = .now

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)

                List {
                    Section(header: Text(formatted(selectedDate))) {
                        Text("No events")
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("Calendar")
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
}


