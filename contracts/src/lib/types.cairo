
#[derive(Copy, Drop, Serde)]
struct Vector2 {
    x: i16,
    y: i16,
}

#[derive(Copy, Drop, Serde)]
struct Action {
    action_type: u8,
    step: u8,
}

#[derive(Clone, Drop, Serde)]
struct CharacterMove {
    character_ids: Array<u32>,
    movement: Array<Vector2>,
    actions: Array<Action>,
}