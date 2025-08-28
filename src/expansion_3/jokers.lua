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