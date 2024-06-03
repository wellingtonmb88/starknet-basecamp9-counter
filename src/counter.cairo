use starknet::ContractAddress;

#[starknet::interface]
trait ICounter<T> {
    fn get_counter(self: @T) -> u32;
    fn increase_counter(ref self: T); 
}

#[starknet::contract]
mod Counter {
    use super::ICounter;

    #[storage]
    struct Storage {
        counter: u32,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initial_counter: u32) {
        self.counter.write(initial_counter); 
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased: CounterIncrease, 
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncrease {
        #[key]
        counter: u32
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }
 
        fn increase_counter(ref self: ContractState) {
            let current_counter = self.counter.read();
            self.counter.write(current_counter + 1);
            self.emit(CounterIncrease { counter: current_counter + 1 });
        }
    }
}
