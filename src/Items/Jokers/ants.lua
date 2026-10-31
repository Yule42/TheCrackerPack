SMODS.Joker{ --Ants
    name = "Ants",
    key = "ants",
    config = {
        extra = {
            x_mult = 1,
            x_mult_add = 1,
        }
    },
    pos = {
        x = 7,
        y = 3,
    },
    order = 15,
    attributes = { 'xmult', 'joker' },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'wombatcountry', 'courier'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue+1] = { set = 'Other', key = 'food_cracker'}
        local x_mult = 1 + card.ability.extra.x_mult * G.GAME.Cracker.food_jokers_destroyed
        return {vars = {x_mult, card.ability.extra.x_mult_add}}
    end,
    
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.Cracker.food_jokers_destroyed > 0 then
            return {
                xmult = 1 + card.ability.extra.x_mult * G.GAME.Cracker.food_jokers_destroyed,
            }
        elseif context.joker_type_destroyed and Cracker.is_food(context.card) then
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { 1 + (card.ability.extra.x_mult * (G.GAME.Cracker.food_jokers_destroyed+1)) } }
            }
        end
    end
}
