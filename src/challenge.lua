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

local challenge = SMODS.Challenge{
    loc_txt = {name = "Circus Act"},
    key = "circusact",
    restrictions = {
        banned_cards = {
            {id = 'j_8_ball'},
            {id = 'j_superposition'},
            {id = 'j_vagabond'},
            {id = 'j_cartomancer'},
            {id = 'j_hallucination'},
            {id = 'j_fortune_teller'},
            {id = 'j_cracker_northstar'},
            {id = 'j_constellation'},
            {id = 'j_satellite'},
            {id = 'j_astronomer'},
            {id = 'j_cracker_postman'},
            {id = 'j_sixth_sense'},
            {id = 'j_certificate'},
            {id = 'v_crystal_ball', ids = {
                'v_crystal_ball','v_omen_globe',
            }},
            {id = 'v_telescope', ids = {
                'v_telescope','v_observatory',
            }},
            {id = 'v_tarot_merchant', ids = {
                'v_tarot_merchant','v_tarot_tycoon',
            }},
            {id = 'v_planet_merchant', ids = {
                'v_planet_merchant','v_planet_tycoon',
            }},
            {id = 'v_magic_trick', ids = {
                'v_magic_trick','v_illusion',
            }},
            {id = 'p_arcana_normal_1', ids = {
                'p_arcana_normal_1','p_arcana_normal_2','p_arcana_jumbo_1','p_arcana_mega_1','p_arcana_normal_3','p_arcana_normal_4','p_arcana_jumbo_2','p_arcana_mega_2',
            }},
            {id = 'p_celestial_normal_1', ids = {
                'p_celestial_normal_1','p_celestial_normal_2','p_celestial_jumbo_1','p_celestial_mega_1','p_celestial_normal_3','p_celestial_normal_4','p_celestial_jumbo_2','p_celestial_mega_2',
            }},
            {id = 'p_spectral_normal_1', ids = {
                'p_spectral_normal_1','p_spectral_normal_2','p_spectral_jumbo_1','p_spectral_mega_1','p_spectral_normal_3','p_spectral_normal_4','p_spectral_jumbo_2','p_spectral_mega_2',
            }},
            {id = 'p_standard_normal_1', ids = {
                'p_standard_normal_1','p_standard_normal_2','p_standard_jumbo_1','p_standard_mega_1','p_standard_normal_3','p_standard_normal_4','p_standard_jumbo_2','p_standard_mega_2',
            }},
        },
        banned_tags = {
            {id = 'tag_standard'},
            {id = 'tag_charm'},
            {id = 'tag_meteor'},
            {id = 'tag_ethereal'},
        }
    },
    rules = {
        custom = {
            {id = 'onlyjokers'}
        }
    }
}

if not disable_card then
    table.insert(challenge.restrictions.banned_cards, 4, {id = 'j_cracker_whitecard'})
end

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