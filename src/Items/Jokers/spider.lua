SMODS.Joker{ -- Spider
    key = "spider",
    config = {
        extra = {
            cards_draw = 13
        }
    },
    pos = {
        x = 7,
        y = 4
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Infamousinvictis', 'palestjade, brook03, sugariimarii'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.cards_draw, localize('Straight Flush', 'poker_hands')}}
    end,
    order = 10,
    attributes = { 'hand_type' },
    calculate = function(self, card, context)
        if context.press_play and not context.blueprint then
            if G.FUNCS.get_poker_hand_info(G.hand.highlighted) == 'Straight Flush' then
                SMODS.draw_cards(card.ability.extra.cards_draw)
                return nil, true
            end
        end
    end
}
