//
//  AccountsView.swift
//  Athena
//
//  Created by Tonia Sanzo on 10/9/25.
//

// TODO: Modify Accounts View to account for the modified Accounts struct. :TODO

import SwiftUI




// begin mod
// @: Tonia Sanzo
// ?: Remove renewalDate, add properties, make properties optional, and move Account to the top of AccountsView.
struct Account: Identifiable, Hashable {
    let id:              UUID
    var name:            String
    var username:        String?
    var email:           String?
    var password:        String?
    var accountProvider: String?
}
// end mod




struct AccountsView: View {
    @State private var accounts: [Account] = []
    @State private var isPresentingNewAccount: Bool = false

    var body: some View {
        NavigationStack {
            List {
                if accounts.isEmpty {
                    ContentUnavailableView("No Accounts", systemImage: "person.crop.circle.badge.questionmark", description: Text("Add your online accounts to keep track of logins and renewal dates."))
                } else {
// begin mod
// @: Tonia Sanzo
// ?: Tweak forEach loop because of the modified Accounts struct.
                    accounts.forEach { account in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(account.name)
                                .font(.headline)
                            if let username = account.username {
                                Text(username)
                                    .foregroundStyle(.secondary)
                            }
                            else if let email = account.email {
                                Text(email)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
// end mod
                }
            }
            .navigationTitle("Accounts")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingNewAccount = true
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewAccount) {
                NewAccountView { newAccount in
                    accounts.append(newAccount)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }
}



private struct NewAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var username: String = ""
    @State private var renewalDate: Date = .now
    @State private var hasRenewal: Bool = false

    let onSave: (Account) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    TextField("Name", text: $name)
                    TextField("Username/Email", text: $username)
                }
                Section("Renewal") {
                    Toggle("Has renewal date", isOn: $hasRenewal.animation())
                    if hasRenewal {
                        DatePicker("Renewal Date", selection: $renewalDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("New Account")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let account = Account(
                            id: UUID(),
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                            renewalDate: hasRenewal ? renewalDate : nil
                        )
                        onSave(account)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || username.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

#Preview {
    AccountsView()
}


