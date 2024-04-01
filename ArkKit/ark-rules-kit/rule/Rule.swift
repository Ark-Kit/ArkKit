protocol Rule<Trigger> {
    associatedtype Trigger: Equatable
    var trigger: Trigger { get }
    var action: any Action { get }
}

struct ArkRule<Trigger>: Rule where Trigger: Equatable {
    let trigger: Trigger
    let action: any Action
}
