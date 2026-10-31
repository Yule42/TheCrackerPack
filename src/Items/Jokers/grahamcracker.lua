SMODS.Joker{ --Graham Cracker
    key = "grahamcracker",
    config = {
        extra = {
            x_mult_add = 1,
            cards_require = 15,
            cards_left = 15,
            x_mult = 1,
            x_mult_max = 5
        }
    },
    pos = {
        x = 2,
        y = 0
    },
    pools = {
        Food = true,
    },
    order = 7,
    attributes = { 'xmult', 'scaling', 'food' },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult_add, card.ability.extra.cards_require, card.ability.extra.cards_left, card.ability.extra.x_mult, card.ability.extra.x_mult_max}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.after and not context.blueprint and card.ability.extra.x_mult >= card.ability.extra.x_mult_max then
            SMODS.destroy_cards(card, { pinch_anim = true })
            return {
                message = localize('k_cracker_eaten_crumble_ex'),
                colour = G.C.RED
            }
        elseif context.before and context.cardarea == G.jokers and not context.blueprint then
            if not Cracker.is_adjacent_to_freezer(card) then
                card.ability.extra.cards_left = card.ability.extra.cards_left - table_length(context.scoring_hand)
            end
            if card.ability.extra.cards_left <= 0 then
                card.ability.extra.cards_left = card.ability.extra.cards_require
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_add",
                    operation = "+",
                    message_key = 'a_xmult',
                    message_colour = G.C.RED
                })
                return nil, true
            end
        end
    end
}
