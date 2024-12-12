/*:
## Exercise - Adopt Protocols: CustomStringConvertible, Equatable, and Comparable
 
 Create a `Human` class with two properties: `name` of type `String`, and `age` of type `Int`. You'll need to create a memberwise initializer for the class. Initialize two `Human` instances.
 */
class Human: CustomStringConvertible, Equatable, Comparable, Codable{
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    //Custom String Convertible
    var description: String {
        return "name: \(name), age: \(age)";
    }
    
    //equatable
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.name == rhs.name && lhs.age == rhs.age
    }
    
    //comparable
    static func < (lhs: Human, rhs: Human) -> Bool {
        if (lhs.age < rhs.age){
            return true
        }
        return false
    }
    
    //Codable
    
    
}

var person1 = Human(name:"brett", age: 16)
var person2 = Human(name: "bob", age: 32)

//:  Make the `Human` class adopt the `CustomStringConvertible` protocol. Print both of your previously initialized `Human` objects.
//extension Human: CustomStringConvertible {
//    var description: String {
//        return "name: \(name), age: \(age)";
//    }
//}

print(person1)
print(person2)

//:  Make the `Human` class adopt the `Equatable` protocol. Two instances of `Human` should be considered equal if their names and ages are identical to one another. Print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are equal to eachother (using `==`). Then print the result of a boolean expression evaluating whether or not your two previously initialized `Human` objects are not equal to eachother (using `!=`).
//extension Human: Equatable{
//    static func == (lhs: Human, rhs: Human) -> Bool {
//        return lhs.name == rhs.name && lhs.age == rhs.age
//    }
//}

print(person1 == person2)
print(person1 != person2)


//:  Make the `Human` class adopt the `Comparable` protocol. Sorting should be based on age. Create another three instances of a `Human`, then create an array called `people` of type `[Human]` with all of the `Human` objects that you have initialized. Create a new array called `sortedPeople` of type `[Human]` that is the `people` array sorted by age.
let person3 = Human(name: "John", age: 87)
var people: [Human] = [person2, person1, person3]

//extension Human: Comparable{
//    static func < (lhs: Human, rhs: Human) -> Bool {
//        if (lhs.age < rhs.age){
//            return true
//        }
//        return false
//    }
//}
print(people)
people.sort()
print(people)
//:  Make the `Human` class adopt the `Codable` protocol. Create a `JSONEncoder` and use it to encode as data one of the `Human` objects you have initialized. Then use that `Data` object to initialize a `String` representing the data that is stored, and print it to the console.
import Foundation

let jsonEncoder = JSONEncoder()
if let jsonData = try? jsonEncoder.encode(person1){
    let jsonString  = String(data: jsonData, encoding: .utf8)
    print(jsonString!)
}



/*:
page 1 of 5  |  [Next: App Exercise - Printable Workouts](@next)
 */
