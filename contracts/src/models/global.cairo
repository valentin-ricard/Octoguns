#[derive(Drop, Serde)]
#[dojo::model]
pub struct Global{
    #[key]
    id: u32,
    pending_sessions: Array<u32>
}

#[generate_trait]
impl GlobalImpl of GlobalTrait {
    fn create_session(ref self: Global, id: u32) {
        self.pending_sessions.append(id);
    } 

    fn remove_session(ref self: Global, id: u32) {
        let sessions = @self.pending_sessions;
        //let mut new = ArrayTrait::new();
        //todo
    } 
}