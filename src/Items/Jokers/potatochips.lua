SMODS.Joker{ --Potato Chips
    name = "Potato Chips",
    key = "potatochips",
    config = {
        extra = {
            chips = 200,
            chips_remove = 100,
        }
    },
    pos = {
        x = 6,
        y = 3,
    },
    order = 19,
    attributes = { 'chips', 'scaling', 'hands' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    pools = {
        Food = true,
    },
    

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.chips, card.ability.extra.chips_remove}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
            }
        elseif context.end_of_round and context.cardarea == G.jokers and not context.blueprint and not context.repetition and not context.individual and G.GAME.current_round.hands_played == 1 then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "chips",
                scalar_value = "chips_remove",
                operation = "-",
                message_key = 'a_chips_minus',
                message_colour = G.C.CHIPS
            })
            if card.ability.extra.chips <= 0 then
                SMODS.destroy_cards(card, { pinch_anim = true })
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.CHIPS
                }
            end
            return nil, true
        end
    end
}
