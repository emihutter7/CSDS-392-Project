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

    var body: some View {
        VStack(spacing: 20) {
            Button("Link Bank Account") {
                showTeller = true
            }
            .buttonStyle(.borderedProminent)

            Button {
                Task {
                    await viewModel.importTransactions(modelContext: modelContext)
                }
            } label: {
                if viewModel.isImporting {
                    ProgressView()
                } else {
                    Text("Import Transactions")
                }
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isImporting)

            if let institution = viewModel.linkedInstitutionName {
                Text("Linked: \(institution)")
                    .font(.subheadline)
            }

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding()
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
