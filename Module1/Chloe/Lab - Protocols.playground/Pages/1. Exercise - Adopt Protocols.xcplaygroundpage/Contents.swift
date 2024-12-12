/*:
## Exercise - Adopt Protocols: CustomStringConvertible, Equatable, and Comparable
 
 Create a `Human` class with two properties: `name` of type `String`, and `age` of type `Int`. You'll need to create a memberwise initializer for the class. Initialize two `Human` instances.
 */
import Foundation

class Human: CustomStringConvertible, Equatable, Comparable, Codable{
    static func < (lhs: Human, rhs: Human) -> Bool {
        return lhs.age<rhs.age
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.name==rhs.name && lhs.age==rhs.age
    }
    
    let name:String
    var age:Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    var description: String{
        return("There is a person named \(name) who is \(age) years old")
    }
    
}

let chloe = Human(name: "Chloe", age: 16), mhiki = Human(name: "Mhiki", age: 16)

//:  Make the `Human` class adopt the `CustomStringConvertible` protocol. Print both of your previously initialized `Human` objects.
//done
print(chloe)
print(mhiki)

//:  Make the `Human` class adopt the `Equatable` protocol. Two instances of `Human` should be considered equal if their names and ages are identical to one another. Print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are equal to eachother (using `==`). Then print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are not equal to eachother (using `!=`).
//done
print(chloe==mhiki)
print(chloe != mhiki)

//:  Make the `Human` class adopt the `Comparable` protocol. Sorting should be based on age. Create another three instances of a `Human`, then create an array called `people` of type `[Human]` with all of the `Human` objects that you have initialized. Create a new array called `sortedPeople` of type `[Human]` that is the `people` array sorted by age.
//done
let brett = Human(name: "Brett", age: 16), lele = Human(name: "Lele", age: 17), mia = Human(name: "Mia", age: 16)
let people = [chloe, mhiki, brett, lele, mia]
let sortedPeople = people.sorted(by: <)

for people in sortedPeople {
  print(people)
}
//:  Make the `Human` class adopt the `Codable` protocol. Create a `JSONEncoder` and use it to encode as data one of the `Human` objects you have initialized. Then use that `Data` object to initialize a `String` representing the data that is stored, and print it to the console.
//done
let jsonEncoder = JSONEncoder()
if let jsonData = try? jsonEncoder.encode(chloe),
    let jsonString = String(data: jsonData, encoding: .utf8) {
    print(jsonString)
    
}

/*:
page 1 of 5  |  [Next: App Exercise - Printable Workouts](@next)
 */
