function Cracker.get_challenge_by_id(challenges_table, id) -- G.CHALLENGES for vanilla challenges
    for _, challenge in pairs(challenges_table) do
        if challenge.id == id then
            print(challenge)
            return challenge
        end
    end
    return nil
end
local omelette = Cracker.get_challenge_by_id(G.CHALLENGES, "c_omelette_1")
local nonperishable = Cracker.get_challenge_by_id(G.CHALLENGES, "c_non_perishable_1")
local blastoff = Cracker.get_challenge_by_id(G.CHALLENGES, "c_blast_off_1")
local fivecard = Cracker.get_challenge_by_id(G.CHALLENGES, "c_five_card_1")
local goldenneedle = Cracker.get_challenge_by_id(G.CHALLENGES, "c_golden_needle_1")

if omelette then
    table.insert(omelette.restrictions.banned_cards, 2, {id = 'v_cracker_silver_spoon'})
    table.insert(omelette.restrictions.banned_cards, 2, {id = 'v_cracker_heirloom'})
    table.insert(omelette.restrictions.banned_cards, {id = 'j_cracker_chocolatecoin'})
    if not disable_card then
        table.insert(omelette.restrictions.banned_cards, {id = 'j_cracker_yellowcard'})
    end
end

if nonperishable then
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_chocolatecoin'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_saltinecracker'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_grahamcracker'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_cheese'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_crackerbarrel'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_curry'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_potatochips'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_shrimpcocktail'})
    table.insert(nonperishable.restrictions.banned_cards, 8, {id = 'j_cracker_hamburger'})
end

if blastoff then
    table.insert(blastoff.restrictions.banned_cards, {id = 'j_cracker_knifethrower'})
    table.insert(blastoff.restrictions.banned_cards, {id = 'j_cracker_hamburger'})
end

if fivecard then
    if not disable_card then
        table.insert(fivecard.restrictions.banned_cards, {id = 'j_cracker_pinkcard'})
    end
end

if goldenneedle then
    table.insert(goldenneedle.restrictions.banned_cards, {id = 'j_cracker_knifethrower'})
    table.insert(goldenneedle.restrictions.banned_cards, {id = 'j_cracker_hamburger'})
end

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
            {id = 'j_marble'},
            {id = 'j_hologram'},
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
    loc_txt = {name = "Mail Call"},
    key = "mailcall",
    jokers = {
        {id = 'j_cracker_postman', eternal = true},
    },
    vouchers = {
    },
    rules = {
        custom = {
        }
    },
    deck = {
        cards = {
			{ s = "D", r = "2", g = "Gold" },
			{ s = "D", r = "3" },
			{ s = "D", r = "4" },
			{ s = "D", r = "5" },
			{ s = "D", r = "6" },
			{ s = "D", r = "7" },
			{ s = "D", r = "8" },
			{ s = "D", r = "9" },
			{ s = "D", r = "T" },
			{ s = "D", r = "J" },
			{ s = "D", r = "Q" },
			{ s = "D", r = "K" },
			{ s = "D", r = "A" },
			{ s = "C", r = "2", g = "Blue" },
			{ s = "C", r = "3" },
			{ s = "C", r = "4" },
			{ s = "C", r = "5" },
			{ s = "C", r = "6" },
			{ s = "C", r = "7" },
			{ s = "C", r = "8" },
			{ s = "C", r = "9" },
			{ s = "C", r = "T" },
			{ s = "C", r = "J" },
			{ s = "C", r = "Q" },
			{ s = "C", r = "K" },
			{ s = "C", r = "A" },
			{ s = "H", r = "2", g = "Red" },
			{ s = "H", r = "3" },
			{ s = "H", r = "4" },
			{ s = "H", r = "5" },
			{ s = "H", r = "6" },
			{ s = "H", r = "7" },
			{ s = "H", r = "8" },
			{ s = "H", r = "9" },
			{ s = "H", r = "T" },
			{ s = "H", r = "J" },
			{ s = "H", r = "Q" },
			{ s = "H", r = "K" },
			{ s = "H", r = "A" },
			{ s = "S", r = "2", g = "Purple" },
			{ s = "S", r = "3" },
			{ s = "S", r = "4" },
			{ s = "S", r = "5" },
			{ s = "S", r = "6" },
			{ s = "S", r = "7" },
			{ s = "S", r = "8" },
			{ s = "S", r = "9" },
			{ s = "S", r = "T" },
			{ s = "S", r = "J" },
			{ s = "S", r = "Q" },
			{ s = "S", r = "K" },
			{ s = "S", r = "A" },
		},
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