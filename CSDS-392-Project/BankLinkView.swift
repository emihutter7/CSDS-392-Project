//
//  BankLinkView.swift
//  CSDS-392-Project
//
//  Created by Alexandra Twitty on 4/21/26.
//
import SwiftUI
import SwiftData
import TellerKit

struct BankLinkView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = BankImportViewModel()
    @State private var showTeller = false

    private let backgroundColor = Color(red: 0.97, green: 0.95, blue: 0.94)
    private let cardColor = Color.white
    private let secondaryAccent = Color(red: 0.55, green: 0.43, blue: 0.35)
    private let fieldBorder = Color(red: 0.88, green: 0.80, blue: 0.81)
    private let softBackground = Color(red: 0.99, green: 0.98, blue: 0.97)

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("Import Transactions")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(secondaryAccent)

                        Text("Securely link your bank account and import recent transactions into your budget tracker.")
                            .font(.system(size: 15))
                            .foregroundStyle(secondaryAccent.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }

                    VStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 14) {
                            Label("Bank Connection", systemImage: "building.columns.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(secondaryAccent)

                            Text("Connect your bank account to automatically pull in transaction data.")
                                .font(.system(size: 14))
                                .foregroundStyle(secondaryAccent.opacity(0.7))

                            Button {
                                showTeller = true
                            } label: {
                                HStack {
                                    Image(systemName: "link")
                                    Text("Link Bank Account")
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color.accentColor)
                                )
                            }

                            if let institution = viewModel.linkedInstitutionName {
                                HStack(spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green)
                                    Text("Linked: \(institution)")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(secondaryAccent)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(softBackground)
                                )
                            }
                        }
                        .padding(18)
                        .background(cardColor)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                        VStack(alignment: .leading, spacing: 14) {
                            Label("Transaction Import", systemImage: "arrow.down.doc.fill")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(secondaryAccent)

                            Text("Once your account is linked, import transactions directly into the app.")
                                .font(.system(size: 14))
                                .foregroundStyle(secondaryAccent.opacity(0.7))

                            Button {
                                Task {
                                    await viewModel.importTransactions(modelContext: modelContext)
                                }
                            } label: {
                                HStack {
                                    if viewModel.isImporting {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "square.and.arrow.down")
                                        Text("Import Transactions")
                                    }
                                }
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(viewModel.isImporting ? Color.gray.opacity(0.6) : secondaryAccent)
                                )
                            }
                            .disabled(viewModel.isImporting)
                        }
                        .padding(18)
                        .background(cardColor)
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.05), radius: 12, y: 6)

                        if !viewModel.statusMessage.isEmpty {
                            Text(viewModel.statusMessage)
                                .font(.system(size: 14))
                                .foregroundStyle(secondaryAccent)
                                .multilineTextAlignment(.center)
                                .padding(14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(softBackground)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(fieldBorder, lineWidth: 1)
                                )
                        }

                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .tellerConnect(
            isPresented: $showTeller,
            config: Teller.Config(
                appId: TellerConfig.applicationId,
                environment: .sandbox,
                selectAccount: .single,
                products: [.transactions, .balance]
            ) { result in
                switch result {
                case .enrollment(let enrollment):
                    viewModel.handleEnrollment(
                        accessToken: enrollment.accessToken,
                        institutionName: enrollment.enrollment.institution.name
                    )
                case .exit:
                    break
                default:
                    break
                }
            }
        )
    }
}

#Preview {
    BankLinkView()
}
