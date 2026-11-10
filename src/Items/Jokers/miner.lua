SMODS.Joker{ -- Miner
    key = "miner",
    config = {
        extra = {
        }
    },
    pos = {
        x = 7,
        y = 5
    },
    attributes = { },
    cost = 5,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'Jokers',
    loc_vars = function(self, info_queue, card)
        if card and card.area and card.area.config.collection then info_queue[#info_queue+1] = {set = 'Other', vars = {'Le Ginger', 'sophiedeergirl'}, key = 'artist_credits_cracker'} end
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.after and not context.blueprint and (to_big(hand_chips) * to_big(mult) + to_big(G.GAME.chips)) >= to_big(G.GAME.blind.chips) then
            local end_round_context = {
                
            }
            local contexter = {cardarea = G.hand, end_of_round = true, beat_boss = G.GAME.blind.boss, cracker_miner = true}
            for i, card in ipairs(context.scoring_hand) do -- this is "SMODS.calculate_end_of_round_effects" but cardarea.cards is swapped with context.scoring_hand
                local reps = {1}
                local j = 1
                while j <= #reps do
                    card.repetition_trigger = j > 1 and j - 1
                    percent = (i-0.999)/(#context.scoring_hand-0.998) + (j-1)*0.1
                    if reps[j] ~= 1 then
                        local _, eff = next(reps[j])
                        SMODS.calculate_effect(eff, eff.card)
                        percent = percent + 0.08
                    end

                    contexter.playing_card_end_of_round = true
                    --calculate the hand effects
                    local effects = {eval_card(card, contexter)}
                    SMODS.calculate_quantum_enhancements(card, effects, contexter)

                    contexter.playing_card_end_of_round = nil
                    contexter.individual = true
                    contexter.other_card = card
                    -- contexter.end_of_round individual calculations

                    SMODS.calculate_card_areas('jokers', contexter, effects, { main_scoring = true })
                    SMODS.calculate_card_areas('individual', contexter, effects, { main_scoring = true })

                    local flags = SMODS.trigger_effects(effects, card)

                    contexter.individual = nil
                    contexter.repetition = true
                    contexter.card_effects = effects
                    if reps[j] == 1 then
                        SMODS.calculate_repetitions(card, contexter, reps)
                    end

                    contexter.repetition = nil
                    contexter.card_effects = nil
                    contexter.other_card = nil
                    j = j + (flags.calculated and 1 or #reps)

                    -- TARGET: effects after end of round evaluation
                end
                card.repetition_trigger = nil
            end
        end
    end
}
