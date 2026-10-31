SMODS.Joker{ --Cracker Barrel
    key = "crackerbarrel",
    config = {
        extra = {
            creation = 1,
            jokersleft = 10,
        }
    },
    pos = {
        x = 2,
        y = 1
    },
    order = 1,
    attributes = { 'generation', 'scaling', 'joker' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'amoryax', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.creation, card.ability.extra.jokersleft}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not self.getting_sliced and not (context.blueprint_card or card).getting_sliced and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
            local jokers_to_create = math.min(1, G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
            if jokers_to_create > 0 and not context.blueprint then
                card.ability.extra.jokersleft = card.ability.extra.jokersleft - 1
            end
            G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
            G.E_MANAGER:add_event(Event({
                func = function() 
                    for _ = 1, jokers_to_create do
                        card = SMODS.add_card {
                            set = 'Joker',
                            attributes = { "food" },
                            key_append = 'crackerbarrel'
                        }
                        G.GAME.joker_buffer = 0
                    end
                    return true
                end}))   
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_joker'), colour = G.C.BLUE}) 
            if card.ability.extra.jokersleft < 1 and not context.blueprint then
                SMODS.destroy_cards(card, { pinch_anim = true })
                return {
                    message = localize('k_cracker_eaten_barrel_ex'),
                    colour = G.C.FILTER
                }
            end
            return nil, true
        end
    end
}
