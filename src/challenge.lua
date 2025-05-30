SMODS.Challenge{
    loc_txt = {name = "Hot Potato"},
    key = "hotpotato",
    jokers = {
        {id = 'j_cracker_bomb', eternal = true},
    },
    rules = {
        modifiers = {
            { id = "joker_slots", value = 6 },
        },
    },
}

SMODS.Challenge{
    loc_txt = {name = "Dance of the Blades"},
    key = "swordsclash",
    jokers = {
        {id = 'j_ceremonial', eternal = true},
        {id = 'j_cracker_sacramentalkatana', eternal = true},
    },
    rules = {
        modifiers = {
            { id = "joker_slots", value = 4 },
        }
    },
    restrictions = {
        banned_cards = {
        }
    }
}

SMODS.Challenge{
    loc_txt = {name = "The End"},
    key = "theend2",
    jokers = {
        {id = 'j_perkeo', edition = "negative"},
        {id = 'j_diet_cola'},
    },
    vouchers = {
    },
    rules = {
        custom = {
            {id = 'ante_39'},
            {id = 'plasma'},
            {id = 'plasma_2'},
        }
    }
}