//
//  EditBudgetView.swift
//  TrackYourSubs
//
//  Created by Max Shelepov on 7/17/22.
//

import SwiftUI

struct EditBudgetView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subViewModel: SubViewModel
    @State var fieldBudget: String = ""
   
    var body: some View {
        ScrollView {
            VStack {
                TextField("$\(subViewModel.budget, specifier: "%.2f")", text: $fieldBudget)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .cornerRadius(10)
                    .keyboardType(.decimalPad)
                Button(action: saveBudgetPressed, label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        
                })
            }.padding(14)
        }
        .navigationTitle("Edit Budget 💵")
    }
    func saveBudgetPressed() {
        // to implement
        subViewModel.setBudget(newBudget: Float(fieldBudget) ?? 0.0)
        presentationMode.wrappedValue.dismiss()
    }
    func setFieldBudget() {
        fieldBudget = String(subViewModel.budget)
    }
}

struct EditBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        EditBudgetView()
            .environmentObject(SubViewModel())
    }
}
