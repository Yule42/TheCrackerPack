SMODS.Challenge{
    loc_txt = {name = "The End"},
    key = "theend",
    jokers = {
        {id = 'j_perkeo'}
    },
    vouchers = {
        {id = 'v_telescope'},
        {id = 'v_directors_cut'},
    },
    rules = {
        custom = {
            {id = 'ante_39'},
            {id = 'plasma'},
            {id = 'plasma_2'},
        }
    }
}

SMODS.Challenge{
    loc_txt = {name = "The End #2"},
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

SMODS.Challenge{
    loc_txt = {name = "The End #3"},
    key = "theend3",
    jokers = {
        {id = 'j_blueprint', edition = "negative"},
        {id = 'j_brainstorm', edition = "negative"},
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

SMODS.Challenge{
    loc_txt = {name = "Hot Potato"},
    key = "hotpotato",
    jokers = {
        {id = 'j_cracker_bomb', eternal = true},
    },
    rules = {
        modifiers = {
            { id = "joker_slots", value = 6 },
        }
    },
}

SMODS.Challenge{
    loc_txt = {name = "Swords Clash"},
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
}