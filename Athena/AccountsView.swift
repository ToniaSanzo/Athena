//
//  AccountsView.swift
//  Athena
//
//  Created by A.I. and Tonia Sanzo on 10/9/25.
//

import SwiftUI




// begin mod
// @: Tonia Sanzo
// ?: Remove renewalDate, add properties, make properties optional, and move Account to the top of
//    AccountsView.

struct Account: Identifiable, Hashable {
    let id:              UUID
    var name:            String
    var username:        String
    var password:        String?
    var accountProvider: String
    var info:            String
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
// ?: Tweak ForEach loop because of the modified Accounts struct.
                    
                    ForEach(accounts) { account in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(account.name)
                                .font(.headline)
                            
                            Text(account.username)
                                .foregroundStyle(.secondary)
                            
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
    
// begin mod
// @: Tonia Sanzo
// ?: Tweak NewAccountView's properties because of the modified Account
//    struct.
    
    @State private var info: String = ""
    @State private var password: String = ""
    @State private var accountProvider: String = ""
    // @State private var renewalDate: Date = .now
    // @State private var hasRenewal: Bool = false
    
// end mod
    
    let onSave: (Account) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Name", text: $name)
                }
                
// begin mod
// @: Tonia Sanzo
// ?: Remove "Renewal" Section, add "Account" and "Additional Info" sections.
                
//                Section("Renewal") {
//                    if hasRenewal {
//                        DatePicker("Renewal Date", selection: $renewalDate, displayedComponents: .date)
//                    }
//                }
                
                Section("Account") {
                    TextField("Username/Email", text: $username)
                    SecureField("Password", text: $password)
                }
                
                Section("Additional Info") {
                    TextField("Account Provider", text: $accountProvider)
                    TextField("Info", text: $info)
                }
            }
            
// end mod
            
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

// begin mod
// @: Tonia Sanzo
// ?: Remove renewalDate and add missing Account properties (member variables).

//                            renewalDate: hasRenewal ? renewalDate : nil
                            password: password.isEmpty ? password : nil,
                            accountProvider: accountProvider.trimmingCharacters(in: .whitespacesAndNewlines),
                            info: info.trimmingCharacters(in: .whitespacesAndNewlines),
                            
// end mod
                            
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


