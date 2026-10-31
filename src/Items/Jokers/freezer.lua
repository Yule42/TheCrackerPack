SMODS.Joker{ --Freezer
    key = "freezer",
    config = {
        extra = {
        }
    },
    pos = {
        x = 4,
        y = 1
    },
    order = 9,
    attributes = { 'passive', 'joker', 'mod_chance' },
    cost = 4,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade','sophiedeergirl'}, key = 'artist_credits_cracker'} end
        info_queue[#info_queue+1] = { set = 'Other', key = 'food_cracker'}
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.mod_probability and Cracker.is_food(context.trigger_obj) and not Cracker.immutable_food[context.trigger_obj.config.center_key] then
            if Cracker.is_adjacent_joker(card, context.trigger_obj) then
                return {
                    numerator = 0
                }
            end
        end
    end,
    calc_scaling = function(self, card, other_card, initial, scalar_value, args)
        local stg = card.ability.extra
        if Cracker.is_food(other_card) and not Cracker.immutable_food[card.key] then
            if Cracker.is_adjacent_joker(card, other_card) then
                return {
                    override_scalar_value = {
                        value = scalar_value * 0
                    },
                    override_message = {
                        message = localize('k_cracker_frozen_ex'),
                    }
                }
            end
        end
    end
}
