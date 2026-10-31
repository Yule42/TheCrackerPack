SMODS.Joker{ --Shrimp Cocktail
    key = "shrimpcocktail",
    config = {
        extra = {
            discards = 3,
            discards_reduction = 1,
        }
    },
    pos = {
        x = 4,
        y = 3,
    },
    order = 39,
    attributes = { 'discard', 'scaling', 'food' },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    pools = {
        Food = true,
    },
    

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'brook03'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.discards, card.ability.extra.discards_reduction, (card.ability.extra.discards == 1 --[[and G.SETTINGS.language == "en-us"]]) and "" or "s", G.GAME.round_resets.discards}}
    end,    
    calculate = function(self, card, context)
        if context.pre_discard and not context.hook and G.GAME.current_round.discards_used >= G.GAME.round_resets.discards and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "discards",
                scalar_value = "discards_reduction",
                operation = "-",
                message_key = 'a_cracker_discards_minus',
                message_colour = G.C.MULT
            })
            if card.ability.extra.discards <= 0 then
                SMODS.destroy_cards(card, { pinch_anim = true })
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
            end
            return nil, true
        elseif context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_discard(card.ability.extra.discards, nil, true)
                    SMODS.calculate_effect(
                        { message = localize { type = 'variable', key = 'a_cracker_discards', vars = { card.ability.extra.discards } } }, context.blueprint_card or card)
                    return true
                end
            }))
            return nil, true
        end
    end
}
