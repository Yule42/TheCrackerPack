SMODS.Joker{ --White Card
    name = "White Card",
    key = "whitecard",
    config = {
        extra = {
            solds = 0
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    attributes = { 'generation', 'tarot', 'scaling', 'reset' },
    cost = 8,
    rarity = 3,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',

    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'sophiedeergirl'}, key = 'concept_credits_cracker'} end
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        return {vars = { card.ability.extra.solds }}
    end,
    
    calculate = function(self, card, context)
        if context.ending_shop and not context.blueprint and card.ability.extra.solds then
            for i=1, card.ability.extra.solds do
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, 'c_fool')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                card:juice_up(0.5, 0.5)
                            return true
                        end)}))
                        card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.PURPLE})
                end
            end
            card.ability.extra.solds = 0
        elseif context.selling_card and not context.blueprint then
            card.ability.extra.solds = card.ability.extra.solds + 1
            return {
                message = localize('k_upgrade_ex')
            }
        end
    end
}
