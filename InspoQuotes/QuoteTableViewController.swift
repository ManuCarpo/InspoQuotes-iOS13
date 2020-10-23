//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {

    //Nome del prodotto che voglio far pagare
    let pruductID = "com.emanuelecarpigna.InspoQuotes.PremiumQuotes"
    
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        SKPaymentQueue.default().add(self)
        
        //ogni volta che l'utente carica l'app, se ha effettuato in precedenza il pagamento allora visualizza l'app nella forma già pagata
        if isPurchased() {
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // se l'utente ha effettuato il pagamento allora elimino l'ultima cella relativa all'effettuare il pagamento
        if isPurchased() {
            return quotesToShow.count
        }
        // se l'utente non ha ancora effettuato il pagamento allora vedrà la cella relativa alla possibilità di effettuare il pagamento
        else {
        return quotesToShow.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)

        if indexPath.row < quotesToShow.count {
        let quotes = quotesToShow[indexPath.row]
        cell.textLabel?.text = quotes
        cell.textLabel?.numberOfLines = 0
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get more Quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }

        return cell
    }
    
   //MARK: -  Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //l'if statement qui sotto sta a indicare: se l'utente clicca sulla cella relativa all' "aggiungi nuove frasi"
        if indexPath.row == quotesToShow.count {
           buyPremiumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK: -  In-App Purchase Methods
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            
            // Process payment for additional functionality offered by your app.
            let paymentRequest = SKMutablePayment()
            // Identify a product that can be purchased from within your app
            paymentRequest.productIdentifier = pruductID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("Can't make payments")
        }
        tableView.reloadData()
        
    }
    
    // Tells an observer that one or more transactions have been updated.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            if transaction.transactionState == .purchased {
                print("Payed")
                showPremiumQuotes()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == . failed {
                
                print("Failed")
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .restored {
                showPremiumQuotes()
                print("Transaction restored")
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    func showPremiumQuotes() {
        UserDefaults.standard.set(true, forKey: pruductID)
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: pruductID)
        if purchaseStatus {
            print("Previusly purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    func isRestored() -> Bool {
        return true
    }
    
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
