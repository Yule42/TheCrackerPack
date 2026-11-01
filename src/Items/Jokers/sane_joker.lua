SMODS.Joker{ -- Sane Joker
    key = "sane_joker",
    config = {
        extra = {
            mult = 0,
            mult_gain = 5,
            poker_hand = 'High Card'
        }
    },
    pos = {
        x = 4,
        y = 5
    },
    attributes = { 'mult', 'scaling', 'destroy_card', 'hand_type' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_gain, localize(card.ability.extra.poker_hand, 'poker_hands')}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        if not G.SETTINGS.paused then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'cracker_sane_joker')
        end
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand and not context.blueprint then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_gain",
                operation = "+"
            })
            card.ability.extra.active = true
            local card_to_destroy = pseudorandom_element(context.full_hand, 'cracker_sane_joker_destruction')
            card_to_destroy.ability.cracker_marked_for_destruction = true
        elseif context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'cracker_sane_joker')
            return {
                message = localize('k_reset')
            }
        elseif context.destroy_card and context.destroy_card.ability.cracker_marked_for_destruction and card.ability.extra.active and not context.blueprint then
            return {
				juice_card = card,
				remove = true,
			}
        elseif context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end
}
