SMODS.Joker{ --Student
    name = "Student",
    key = "student",
    config = {
        extra = {
        }
    },
    pos = {
        x = 0,
        y = 4,
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    in_pool = function(self, args)
        for k, v in pairs(G.playing_cards) do
            if v.config.center.key == 'm_cracker_multi' or v.config.center.key == 'm_cracker_sequenced' then
                return true
            end
        end
    end,
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_multi
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_sequenced
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and not context.repetition_only then
            if context.other_card.config.center.key == 'm_cracker_sequenced' or context.other_card.config.center.key == 'm_cracker_multi' then
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card,
                }
            end
        end
    end
}

SMODS.Joker{ --Silver Coin
    name = "Silver Coin",
    key = "silver_coin",
    config = {
        extra = {
            dollars = 4,
        }
    },
    pos = {
        x = 1,
        y = 4,
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_cracker_silver',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimari'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_cracker_silver
        return {vars = {card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.individual then
            if context.other_card.config.center.key == 'm_cracker_silver' then
                return {
                    dollars = card.ability.extra.dollars
                }
            end
        end
    end
}

SMODS.Joker{ --Multijoker
    name = "Multijoker",
    key = "multijoker",
    config = {
        extra = {
            mult = 4,
        }
    },
    pos = {
        x = 2,
        y = 4,
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_mult',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'eternalqueenmelori'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
        local mult_count = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_mult') then mult_count = mult_count + 1 end
            end
        end
        return {vars = {card.ability.extra.mult, mult_count * card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local mult_count = 0
            for _, playing_card in ipairs(G.playing_cards) do
                if SMODS.has_enhancement(playing_card, 'm_mult') then mult_count = mult_count + 1 end
            end
            return {
                mult = card.ability.extra.mult * mult_count,
            }
        end
    end
}

SMODS.Joker{ --Bonus Joker
    name = "Bonus Joker",
    key = "bonus_joker",
    config = {
        extra = {
            odds = 4,
        }
    },
    pos = {
        x = 3,
        y = 4,
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    enhancement_gate = 'm_bonus',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'None', 'sugariimari'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bonus_joker')
        return {vars = {new_numerator, new_denominator}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local aura_card = context.other_card
            if context.other_card:get_edition() == nil and not aura_card.bonus_joker_mark and SMODS.pseudorandom_probability(card, 'bonus_joker', 1, card.ability.extra.odds, 'bonus_joker') then
                local edition = poll_edition('bonus_joker', nil, true, true, { 'e_holo', 'e_foil' })
                aura_card.bonus_joker_mark = true
                local target_card = aura_card
                local triggering_card = context.blueprint and context.blueprint_card or card
                target_card:set_edition(edition, true, true, true)
                G.E_MANAGER:add_event(Event {
                    trigger = 'after',
                    delay = 0.0,
                    func = function()
                        if edition == 'e_foil' then play_sound('foil1', 1.2, 0.4) end
                        if edition == 'e_holo' then play_sound('holo1', 1.2*1.58, 0.4) end
                        triggering_card:juice_up(0.3, 0.5)
                        target_card.bonus_joker_mark = nil
                        return true
                    end
                })
            end
        end
    end
}