//
//  HomeView.swift
//  Athena
//
//  Created by A.I. and Tonia Sanzo on 10/9/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Today") {
                    Text("No tasks yet")
                    Text("No events today")
                }
                Section("Quick Links") {
                    Label("Calendar", systemImage: "calendar")
                    Label("Accounts", systemImage: "person.crop.circle")
                    Label("Finances", systemImage: "dollarsign.circle")
                }
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}


