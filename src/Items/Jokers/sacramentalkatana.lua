SMODS.Joker{ --Sacramental Katana
    key = "sacramentalkatana",
    config = {
        extra = {
            x_mult = 1,
            x_mult_gain = 0.75,
        }
    },
    pos = {
        x = 3,
        y = 1
    },
    order = 38,
    attributes = { 'xmult', 'destroy_card', 'scaling', 'debuff' },
    cost = 8,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = {set='Other',key='d_sacrifice'}
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'palestjade', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.x_mult, card.ability.extra.x_mult_gain}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main and context.scoring_hand and card.ability.extra.x_mult > 1 then
            return {
                xmult = card.ability.extra.x_mult,
            }
        elseif context.end_of_round and not context.blueprint and context.main_eval and G.GAME.blind.boss then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                local sliced_card = G.jokers.cards[my_pos+1]
                G.GAME.banned_keys[G.jokers.cards[my_pos+1].config.center_key] = true
                sliced_card.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card:juice_up(0.8, 0.8)
                    sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
                SMODS.scale_card(card, {
                    ref_table = card.ability.extra,
                    ref_value = "x_mult",
                    scalar_value = "x_mult_gain",
                    message_key = 'a_xmult'
                })
                return nil, true
            else
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_disabled_ex'), colour = G.C.FILTER, delay = 0.45 })
                card.ability.perma_debuff = true
            end
        end
    end
}
