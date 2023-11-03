//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by Даниил Кизельштейн on 01.11.2023.
//

import Foundation
import CoreData
import Combine

protocol PortfolioData {
    var savedEntitiesPublisher: Published<[PortfolioEntity]>.Publisher { get }
    func updatePortfolio(coin: CoinModel, amount: Double)
}

final class PortfolioDataService: PortfolioData {
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published private var savedEntities: [PortfolioEntity] = []
    
    var savedEntitiesPublisher: Published<[PortfolioEntity]>.Publisher {
        $savedEntities
    }

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { [weak self] (_, error) in
            guard let self else { return }
            if let error = error {
                print("Error loading Core Data: \(error.localizedDescription)")
            } else {
                self.getPortfolio()
            }
        }
    }
    
    //MARK: - Public functions
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        
        //check if coin is already in portfolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id}) {
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
            
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: - Private functions
    
    private func getPortfolio()  {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching PortfolioEntity. \(error)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving data in Core Data: \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
}
