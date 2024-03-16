protocol Action {
    func execute<Event: ArkEvent>(_ event: Event,
                                  eventContext: ArkEventContext,
                                  ecsContext: ArkECSContext)
}
