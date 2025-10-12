//
//  ContentView.swift
//  Athena
//
//  Created by A.I. and Tonia Sanzo on 10/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            CalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            AccountsView()
                .tabItem {
                    Label("Accounts", systemImage: "person.2")
                }

            FinancesView()
                .tabItem {
                    Label("Finances", systemImage: "dollarsign.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
