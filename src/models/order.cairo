use::starknet::ContractAddress;

#[derive(Drop,Serde)]
 enum OrderStatus{
    Pending,
    Completed,
    Cancelled,
 }

 #[derive(Drop,Serde)]
 struct Order {
    id:u64.
    lisitng_id:u64,
    buyer:ContractAddress,
    seller:ContractAddress,
    total_price:u64,
    status:OrderStatus,
    created_at:u64,
    quantity:u64,
 }