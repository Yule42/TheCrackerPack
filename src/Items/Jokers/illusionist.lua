SMODS.Joker{ -- Illusionist
    key = "illusionist",
    config = {
        extra = {
            cards = 5,
        }
    },
    pos = {
        x = 2,
        y = 5
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    attributes = { 'modify_card', 'enhancements', 'hands' },
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = { card.ability.extra.cards }}
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if #context.scoring_hand >= card.ability.extra.cards then
                context.full_hand[3]:set_ability(SMODS.poll_enhancement({ key = 'cracker_illusionist', type_key = 'cracker_illusionist_enhancement', guaranteed = true }), nil, true)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        context.full_hand[3]:juice_up()
                        return true
                    end
                }))
                return {
                    message = localize('k_cracker_enhanced_ex')
                }
            end
        end
    end,
}
