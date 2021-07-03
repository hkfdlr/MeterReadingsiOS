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
    var pickedMeterType = MeterType.power

    @State private var showingAlert = false
    @State private var selectedType: MeterType = MeterType.power

    var body: some View {
                        
        VStack {
            List {
                ForEach(meterList) {
                    meter in
                    NavigationLink(destination: ChartView(meter: binding(for: meter), sheetEnteredValue: 0, sheetPickedDate: Date(), readingData: [])) {
                        MeterRow(meter: meter)
                    }
                }
            }
            .navigationBarTitle(self.account.title)
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
    }
    
    private func binding(for meter: Meter) -> Binding<Meter> {
        guard let meterIndex = meterList.firstIndex(where: { $0.meterNumber == meter.meterNumber }) else {
            fatalError("Can't find meter in array")
        }
        return $meterList[meterIndex]
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
            var newMeter = Meter(id: nil, meterNumber: Int(alert.textFields![1].text!) ?? -1, accountNumber: account.accountNumber, title: alert.textFields![0].text ?? "", meterType: selectedType /* TODO */, meterReadingEntries: [])
            do {
                try saveMeter(meter: &newMeter)
                try getAllMeters(accountNumber: account.accountNumber)
            } catch {
                debugPrint(error)
            }
        })
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
    
    mutating func setPicker(type: MeterType) {
         pickedMeterType = type
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
