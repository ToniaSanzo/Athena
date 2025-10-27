//
//  FinancesView.swift
//  Athena
//
//  Created by A.I. and Tonia Sanzo on 10/9/25.
//

import SwiftUI




// begin mod
// @: Tonia Sanzo
// ?: Add TransactionFrequency enum.

enum TransactionFrequency: String, CaseIterable, Identifiable {
    case once      = "Once"
    case daily     = "Daily"
    case weekly    = "Weekly"
    case biweekly  = "Biweekly"
    case monthly   = "Monthly"
    case quarterly = "Quarterly"
    case annually  = "Annually"
    
    var id: String { rawValue }
}

// end mod




// begin mod
// @: Tonia Sanzo
// ?: Modify Transaction struct.

struct Transaction: Identifiable, Hashable {
    let id:           UUID
    var name:         String
    var frequency:    TransactionFrequency
    var amount:       Double
    var counterparty: String
    var info:         String
//    var account:      Account?
//    var category:     String
    var date:         Date
}

// end mod




struct FinancesView: View {
    @State private var transactions: [Transaction] = []
    @State private var isPresentingNewTransaction: Bool = false

    var body: some View {
        NavigationStack {
            VStack {
                if transactions.isEmpty {
                    ContentUnavailableView("No Transactions", systemImage: "creditcard", description: Text("Track expenses and income to stay on top of your budget."))
                } else {
                    List {
                        
                        
// begin mod
// @: Tonia Sanzo
// ?: Modify how the list of transactions are displayed.
                        
                        ForEach(transactions) { transaction in
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(transaction.name)
                                        .font(.headline)
                                    
                                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                }
                                
                                Spacer()
                                
                                Text(formatAmount(transaction.amount))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(transaction.amount < 0 ? .red : .green)
                                
                                switch transaction.frequency {
                                case .once:
                                    Text("/ Once")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                case .daily:
                                    Text("/ Day")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                
                                case .weekly:
                                    Text("/ Week")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                
                                case .biweekly:
                                    Text("/ Two Weeks")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                
                                case .monthly:
                                    Text("/ Month")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                
                                case .quarterly:
                                    Text("/ Quarter")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                
                                case .annually:
                                    Text("/ Year")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                
                                }
                            }
                        }
                        
// end mod
                        
                    }
                }
            }
            .navigationTitle("Finances")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingNewTransaction = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingNewTransaction) {
                NewTransactionView { newTxn in
                    transactions.append(newTxn)
                }
                .presentationDetents([.medium, .large])
            }
        }
    }

    private func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
}




private struct NewTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    
// begin mod
// @: Tonia Sanzo
// ?: Tweak NewTransactionView's properties because of the modified Transaction
//    struct.
    
    @State private var amountText:   String               = ""
    @State private var name:         String               = ""
    @State private var frequency:    TransactionFrequency = .once
    @State private var counterparty: String               = ""
    @State private var info:         String               = ""
//    @State private var account:      String               = ""
    @State private var date:         Date                 = .now
    
// end mod

    let onSave: (Transaction) -> Void

    var body: some View {
        NavigationStack {
            Form {
                
// begin mod
// @: Tonia Sanzo
// ?: Modify the transaction form.
                
                Section("Details") {
                    TextField("Name", text: $name)
                    TextField("Amount (e.g. -12.99 for expense)", text: $amountText)
                        .keyboardType(.decimalPad)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Picker("Frequency", selection: $frequency) {
                        ForEach(TransactionFrequency.allCases) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                    .pickerStyle(.menu)
                    .padding()
                    TextField("Counterparty", text: $counterparty)
                    TextField("Additional Info", text: $info)
//                    TextField("Account", text: $account)

// end mod
                    
                }
            }
            .navigationTitle("New Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0
                        
// begin mod
// @: Tonia Sanzo
// ?: Update the Transaction instance initialization.
                        
                        let txn =
                            Transaction(id: UUID(), name: name.trimmingCharacters(in: .whitespacesAndNewlines), frequency: frequency, amount: amount, counterparty: counterparty.trimmingCharacters(in: .whitespacesAndNewlines), info: info.trimmingCharacters(in: .whitespacesAndNewlines), date: date)
                        
// end mod
                        
                        onSave(txn)
                        dismiss()
                    }
                    .disabled(Double(amountText.replacingOccurrences(of: ",", with: ".")) == nil)
                }
            }
        }
    }
}

#Preview {
    FinancesView()
}


