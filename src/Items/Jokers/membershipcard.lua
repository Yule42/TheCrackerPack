SMODS.Joker{ --Membership Card
    name = "Membership Card",
    key = "membershipcard",
    config = {
        extra = {
            money = 1,
        }
    },
    pos = {
        x = 1,
        y = 2
    },
    order = 3,
    attributes = { 'scaling', 'economy', 'sell_value' },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.money}}
    end,
    
    calculate = function(self, card, context)
        if (context.buying_card or (context.open_booster and G.shop)) and not context.blueprint and not context.buying_self then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.money
            card:set_cost()
            G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                        message = localize('k_val_up'),
                        colour = G.C.MONEY,
                        card = card
                    }) 
                    return true
                end}))
            return nil, true
        end
    end
}
