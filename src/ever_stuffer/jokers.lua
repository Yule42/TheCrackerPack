SMODS.Joker{ --Knight
    name = "knight",
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
    name = "skillet",
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
    name = "Sophia",
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
