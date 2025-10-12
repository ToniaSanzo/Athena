//
//  FinancesView.swift
//  Athena
//
//  Created by A.I. and Tonia Sanzo on 10/9/25.
//

import SwiftUI

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
                        ForEach(transactions) { txn in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(txn.category)
                                        .font(.headline)
                                    Text(txn.date.formatted(date: .abbreviated, time: .omitted))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(formatAmount(txn.amount))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(txn.amount < 0 ? .red : .green)
                            }
                        }
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

struct Transaction: Identifiable, Hashable {
    let id: UUID
    var amount: Double
    var category: String
    var date: Date
}

private struct NewTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amountText: String = ""
    @State private var category: String = "General"
    @State private var date: Date = .now

    let onSave: (Transaction) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Amount (e.g. -12.99 for expense)", text: $amountText)
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $category)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
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
                        let txn = Transaction(id: UUID(), amount: amount, category: category.trimmingCharacters(in: .whitespacesAndNewlines), date: date)
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


