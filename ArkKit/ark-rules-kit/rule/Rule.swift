protocol Rule<Trigger> {
    associatedtype Trigger: Equatable
    associatedtype Data

    var trigger: Trigger { get }
    var action: any Action<Data> { get }
}

struct ArkRule<Trigger, Data>: Rule where Trigger: Equatable {
    let trigger: Trigger

    let action: any Action<Data>
}
