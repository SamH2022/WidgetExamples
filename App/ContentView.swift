// The MIT License (MIT)
//
// Copyright (c) 2020-Present Paweł Wiszenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import CoreData
import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(entity: Item.entity(), sortDescriptors: []) private var items: FetchedResults<Item>
    @AppStorage(Key.luckyNumber.rawValue, store: .appGroup) private var luckyNumber = 0
    @State private var contacts = Contact.getAll()

    var body: some View {
        List {
            appGroupWidgetSection
            coreDataWidgetSection
            deepLinkWidgetSection
            dynamicIntentWidgetSection
            previewWidgetSection
        }
        .listStyle(InsetGroupedListStyle())
    }
}

// MARK: - AppGroup Widget

extension ContentView {
    private var appGroupWidgetSection: some View {
        Section(header: Text("AppGroup Widget")) {
            Text("Lucky number: \(luckyNumber)")
            Button("Generate new lucky number") {
                luckyNumber = Int.random(in: 1 ... 99)
                WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.appGroup)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
        }
        .onChange(of: luckyNumber) { _ in
            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
            try? String(luckyNumber).write(to: url, atomically: false, encoding: .utf8)
        }
    }
}

// MARK: - CoreData Widget

extension ContentView {
    private var coreDataWidgetSection: some View {
        Section(header: Text("CoreData Widget")) {
            Text("Items count: \(items.count)")
            addNewItemsButton
            deleteAllItemsButton
        }
        .onChange(of: luckyNumber) { _ in
            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
            try? String(luckyNumber).write(to: url, atomically: false, encoding: .utf8)
        }
    }

    private var addNewItemsButton: some View {
        Button("Add new item") {
            let context = CoreDataStack.shared.workingContext
            let item = Item(context: context)
            item.name = "test"
            item.count = 1
            CoreDataStack.shared.saveWorkingContext(context: context)
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.coreData)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.accentColor)
    }

    private var deleteAllItemsButton: some View {
        Button("Delete all items") {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try CoreDataStack.shared.managedObjectContext.executeAndMergeChanges(deleteRequest)
            } catch {
                print(error.localizedDescription)
            }
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.coreData)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(.red)
    }
}

// MARK: - DeepLink Widget

extension ContentView {
    private var deepLinkWidgetSection: some View {
        Section(header: Text("DeepLink Widget")) {
            Text("")
                .onOpenURL { url in
                    if url.scheme == "widget-DeepLinkWidget", url.host == "widgetFamily" {
                        let widgetFamily = url.lastPathComponent
                        print("Opened from widget of size: \(widgetFamily)")
                    }
                }
        }
    }
}

// MARK: - Dynamic Intent Widget

extension ContentView {
    private var dynamicIntentWidgetSection: some View {
        Section(header: Text("Dynamic Intent Widget")) {
            ForEach(contacts.indices, id: \.self) { index in
                HStack {
                    TextField("", text: $contacts[index].name, onCommit: saveContacts)
                    DatePicker("", selection: $contacts[index].dateOfBirth, displayedComponents: .date)
                        .onChange(of: contacts[index].dateOfBirth) { _ in
                            saveContacts()
                        }
                }
            }
        }
    }

    private func saveContacts() {
        let key = UserDefaults.Keys.contacts.rawValue
        UserDefaults.appGroup.setArray(contacts, forKey: key)
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.dynamicIntent)
    }
}

// MARK: - Preview Widget

extension ContentView {
    private var previewWidgetSection: some View {
        let entry = PreviewWidgetEntry(date: Date(), systemImageName: "star.fill")
        return Section(header: Text("Preview Widget")) {
            HStack {
                PreviewWidgetEntryView(entry: entry)
                    .frame(width: 200, height: 200)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
