//
//  AccountDetailView.swift
//  MeterReadings
//
//  Created by Student on 10.06.21.
//
import SwiftUI
import MeterReadingsCore
import MeterReadingsInfrastructure

struct AccountDetailView: View {
    @EnvironmentObject var viewModel: AccountDetailViewModel
    
    @State private var showingAlert = false
    @State private var selectedType: MeterType = MeterType.power
    
    var pickedMeterType = MeterType.power

    var body: some View {
                        
        VStack {
            List {
                ForEach(viewModel.meterList) {
                    meter in
                    NavigationLink(destination: ChartView()
                                    .environmentObject(ChartViewModel(meter: meter))) {
                        MeterRow(meter: meter)
                    }
                }
                .onDelete(perform: {
                    viewModel.deleteMeter(at: $0)
                })
            }
            .navigationBarTitle(viewModel.account.title)
            .toolbar(content: {
                Button("Add", action: {
                    showAlert()
                })
            })
            .onAppear {
                do {
                    try viewModel.getAllMeters(accountNumber: viewModel.account.accountNumber)
                } catch {
                    debugPrint(error)
                }
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Add Meter", message: "Please enter a name for the meter, its meter number and a reading value \n\n\n\n\n\n", preferredStyle: .alert)
        
        alert.addTextField { meterTitle in
            meterTitle.text = ""
            meterTitle.placeholder = "Meter name"
        }
        alert.addTextField { meterNo in
            meterNo.keyboardType = UIKeyboardType.numbersAndPunctuation
            meterNo.text = ""
            meterNo.placeholder = "Meter number"
        }
        
        let pickerView = TypePickerView(selectedType: $selectedType)
        let pickerHost = UIHostingController(rootView: pickerView)
        
        let frame = CGRect(x: -60
                           , y: 85
                           
                           , width: UIScreen.main.bounds.width
                           , height: 100)
        
        pickerHost.view.frame = frame
        pickerHost.view.backgroundColor = UIColor(white: 1, alpha: 0
        )
        alert.view.addSubview(pickerHost.view)

        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in
            
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            var newMeter = Meter(id: nil, meterNumber: Int(alert.textFields![1].text!) ?? -1, accountNumber: viewModel.account.accountNumber, title: alert.textFields![0].text ?? "", meterType: selectedType /* TODO */, meterReadingEntries: [])
            do {
                try viewModel.saveMeter(meter: &newMeter)
                try viewModel.getAllMeters(accountNumber: viewModel.account.accountNumber)
            } catch {
                debugPrint(error)
            }
        })
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    mutating func setPicker(type: MeterType) {
         pickedMeterType = type
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView()
            .environmentObject(AccountDetailViewModel(account: Account(id: nil, accountNumber: 123, title: "asd"))
        )
    }
}
