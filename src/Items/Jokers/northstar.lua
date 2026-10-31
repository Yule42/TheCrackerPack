SMODS.Joker{ --Northern Star
    key = "northstar",
    config = {
        extra = {
            odds = 2,
        }
    },
    pos = {
        x = 8,
        y = (SMODS.current_mod.config.starlo or (os.date("*t").month == 4 and os.date("*t").day == 1)) and 2 or 1
    },
    order = 8,
    attributes = { 'chance', 'hand_type' },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'mrkyspices', 'sugariimarii'}, key = 'artist_credits_cracker'} end
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cracker_northstar')
        return {vars = {new_numerator, new_denominator}}
    end,
    calculate = function(self, card, context)
        if context.skipping_booster and SMODS.pseudorandom_probability(card, 'cracker_northstar', 1, card.ability.extra.odds, 'cracker_northstar') then
            local hand = Cracker.mostplayedhand()
            update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(hand, 'poker_hands'), chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level=G.GAME.hands[hand].level})
            level_up_hand(card, hand)
            update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
            return nil, true
        end
    end
}
