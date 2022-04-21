import Foundation
struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
let MONEY_CURRENCY = ["USD": 1, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
public struct Money {
    let amount: Int
    let currency: String
    
    func convert(_ currency: String) -> Money {
        let selfValue: Double = MONEY_CURRENCY[self.currency]!
        let targetValue: Double = MONEY_CURRENCY[currency]!
        let targetAmout: Int = Int(Double(amount) / selfValue * targetValue)
        
        return Money(amount: targetAmout, currency: currency)
    }
    func add(_ money: Money) -> Money {
        let newMoney: Money = self.convert(money.currency)
        return Money(amount: newMoney.amount + money.amount, currency: money.currency)
    }
    
    func subtract(_ money: Money) -> Money {
        let newMoney: Money = self.convert(money.currency)
        return Money(amount: newMoney.amount - money.amount, currency: money.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
        
        func get() -> Any {
            switch self {
            case .Hourly(let double):
                return double
            case .Salary(let uInt):
                return uInt
            }
        }
    }
    
    func calculateIncome(_ amount: Int) -> Int {
        if case let .Hourly(i) = type {
            return Int(Double(amount) * i)
        }
        
        if case let .Salary(i) = type {
            return Int(i)
        }
        
        return -1
    }
    
    func raise(byPercent: Double) {
        
        if case let .Hourly(i) = type {
            self.type = JobType.Hourly(i * (1.0 + byPercent))
        }
        
        if case let .Salary(i) = type {
            self.type = JobType.Salary(UInt(Double(i) * (1.0 + byPercent)))
        }
    }
    
    
    func raise(byAmount: Int) {
        if case .Hourly = type {
            let number = (self.type.get() as! Double) + (Double(byAmount))
            self.type = JobType.Hourly(number)
        }
        
        if case .Salary = type {
            let number = (self.type.get() as! UInt) + UInt(byAmount)
            self.type = JobType.Salary(number)
        }
    }
    
    
    func raise(byAmount: Double) {
        if case .Hourly = type {
            let number = (self.type.get() as! Double) + byAmount
            self.type = JobType.Hourly(number)
        }
        
        if case .Salary = type {
            let number = (self.type.get() as! UInt) + UInt(byAmount)
            self.type = JobType.Salary(number)
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    var job: Job? {
        didSet {
            if self.age < 21 {
                self.job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if self.age < 21 {
                self.spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.type.get() ?? "nil") spouse:\(spouse?.firstName ?? "nil")]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: [Person]
    let spouse1: Person?
    let spouse2: Person?
    
    init(spouse1: Person, spouse2: Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members = [spouse1, spouse2]
            self.spouse1 = spouse1
            self.spouse2 = spouse2
        } else {
            members = []
            self.spouse2 = nil
            self.spouse1 = nil
        }
    }
    
    func haveChild(_ child: Person) {
        if (spouse1!.age > 21 || spouse2!.age > 21) {
            members.append(child)
        }
    }
    
    func householdIncome() -> Int {
        var res: Int = 0
        for member in members {
            if (member.job != nil) {
                res += member.job!.calculateIncome(2000)
            }
        }
        
        return res
    }
}
