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
    @Binding var account: Account
    @State var meterList: [Meter]
    
    let meterSaver = ConcreteSaveMeterCommand(meterSaver: SaveMeterAdapter())
    let meterGetter = ConcreteGetMeterCommand(meterGetter: GetMeterAdapter())
        
    var body: some View {
        List {
            ForEach(meterList) {
                meter in
                NavigationLink(destination: ChartView(meter: binding(for: meter))) {
                    MeterRow(meter: meter)
                }
            }
        }
        .navigationBarTitle(account.title)
        .toolbar(content: {
            Button("Add", action: {
                showAlert()
            })
        })
        .onAppear {
            do {
                try getAllMeters(accountNumber: account.accountNumber)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    private func binding(for meter: Meter) -> Binding<Meter> {
        guard let meterIndex = meterList.firstIndex(where: { $0.meterNumber == meter.meterNumber }) else {
            fatalError("Can't find meter in array")
        }
        return $meterList[meterIndex]
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Add Meter", message: "Please enter a name for the meter, its meter number and a reading value", preferredStyle: .alert)
        
        alert.addTextField { meterTitle in
            meterTitle.text = ""
            meterTitle.placeholder = "Meter name"
        }
        alert.addTextField { meterNo in
            meterNo.keyboardType = UIKeyboardType.numbersAndPunctuation
            meterNo.text = ""
            meterNo.placeholder = "Meter number"
        }
        alert.addTextField { readingValue in
            readingValue.text = ""
            readingValue.placeholder = "Reading Value"
            readingValue.keyboardType = UIKeyboardType.numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) { _ in

        })
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { _ in
            var newMeter = Meter(id: nil, meterNumber: Int(alert.textFields![1].text!)!, accountNumber: account.accountNumber, title: alert.textFields![0].text!, meterType: MeterType.power /* TODO */, meterReadingEntries: [])
            do {
                try saveMeter(meter: &newMeter)
                try getAllMeters(accountNumber: account.accountNumber)
            } catch {
                debugPrint(error)
            }
        })

        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    func saveMeter(meter: inout Meter) throws {
        try meterSaver.saveMeter(meter: &meter) {
            switch $0 {
            case let .success(value): debugPrint(value)
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
        try getAllMeters(accountNumber: account.accountNumber)
    }
    
    func getAllMeters(accountNumber: Int) throws {
        try meterGetter.getMeters(accountNumber: accountNumber) {
            switch $0 {
            case let .success(meters): do {
                for elem in meters {
                    if (!self.meterList.contains(elem)) {
                        let lastIndex = self.meterList.endIndex
                        self.meterList.insert(elem, at: lastIndex)
                    }
                }
            }
            case let .failure(error): debugPrint(error.localizedDescription)
            }
        }
    }
}

struct AccountDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDetailView(account: .constant(Account.data[0]), meterList: Meter.data
        )
    }
}
