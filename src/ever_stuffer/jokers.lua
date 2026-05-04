SMODS.Joker{ --Knight
    key = "knight",
    config = {
        extra = {
        }
    },
    pos = {
        x = 0,
        y = 4,
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    attributes = { 'passive', 'face' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimarii, lumahoneyy', 'sugariimarii, sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and not context.blueprint then
            if context.other_card:is_face() then
                return {
                    add_to_hand = true,
                }
            end
        elseif context.debuff_card and not context.blueprint then
            if context.debuff_card:is_face() then
                return {
                    prevent_debuff = true,
                }
            end
        end
    end
}

SMODS.Joker{ --Skillet
    key = "skillet",
    config = {
        extra = {
            x_mult = 2,
        }
    },
    pos = {
        x = 1,
        y = 4,
    },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    attributes = { 'xmult' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'no on e :(', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = { card.ability.extra.x_mult }}
    end,
    calculate = function(self, card, context)
        if context.other_joker and Cracker.is_food(context.other_joker) then
            return {
                xmult = card.ability.extra.x_mult
            }
        end
    end
}

SMODS.Joker{ --Sophia
    key = "sophia",
    config = {
        extra = {
            x_mult = 1,
            x_mult_add = 0.1
        }
    },
    pos = {
        x = 1,
        y = 3,
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    attributes = { 'xmult', 'scaling' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sophiedeergirl'}, key = 'concept_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.cardarea == G.play and context.individual and next(SMODS.get_enhancements(context.other_card)) and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "x_mult",
                scalar_value = "x_mult_add",
                operation = "+",
                no_message = true
            })
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                message_card = card
            }
        end
    end
}

SMODS.Joker{ --LegendaryTest
    key = "testLegendary",
    config = {
        extra = {
            retriggers = 0,
            retriggers_increase = 1,
            cards_require = 50,
            cards_left = 50,
        }
    },
    pos = {
        x = 2,
        y = 4
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'who do you think', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.retriggers, card.ability.extra.cards_require, card.ability.extra.cards_left, card.ability.extra.retriggers_increase, (card.ability.extra.retriggers ~= 1 and "s" or "")}}
    end,
    
    calculate = function(self, card, context)
        if card.ability.extra.retriggers > 0 and context.repetition and (context.cardarea == G.play or (context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1))) and not context.repetition_only then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.retriggers,
                card = card,
            }
        elseif context.before and context.cardarea == G.jokers and not context.blueprint then
            card.ability.extra.cards_left = card.ability.extra.cards_left - (table_length(context.scoring_hand))
            if card.ability.extra.cards_left <= 0 then
                card.ability.extra.cards_left = card.ability.extra.cards_require
                card.ability.extra.retriggers = card.ability.extra.retriggers + card.ability.extra.retriggers_increase
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.ATTENTION
                }
            end
        end
    end
}

SMODS.Joker{ --U.F.O.
    key = "ufo",
    config = {
        extra = {
            chips = 0,
            mult = 0,
        }
    },
    pos = {
        x = 3,
        y = 4
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sugariimari', 'sophiedeergirl, sugariimari'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.chips, card.ability.extra.mult}}
    end,
    
    calculate = function(self, card, context)
        if context.before and G.GAME.hands[context.scoring_name].level > 1 and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_table = G.GAME.hands[context.scoring_name],
                scalar_value = "l_mult",
            })
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_table = G.GAME.hands[context.scoring_name],
                scalar_value = "l_chips",
                no_message = true
            })
            return {
                level_up = -1,
                no_retrigger = true
            }
		end
		if context.joker_main then
			return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
		end
    end
}
