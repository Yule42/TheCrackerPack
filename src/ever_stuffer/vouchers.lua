Cracker.card_pack_supported = {
    b_red = true,
    b_blue = true,
    b_yellow = true,
    b_green = true,
    b_black = true,
    b_plasma = true,
}
Cracker.card_pack_erratic_compatible = {
    b_red = true,
    b_blue = true,
    b_yellow = true,
    b_green = true,
    b_black = true,
    b_plasma = true,
}
Cracker.card_pack_redeem = {
    b_red = function(self, card)
        SMODS.change_discard_limit(1)
    end,
    b_blue = function(self, card)
        SMODS.change_play_limit(1)
    end
}
Cracker.card_pack_calculate = {
    b_black = function(self, card, context)
        if context.setting_blind then
            local jokr = 0
            for _, joker in ipairs(G.jokers.cards) do
                if joker.config.center.rarity ~= 1 then
                    jokr = jokr + 1
                end
            end
            if jokr > 1 then
                ease_discard(math.floor(jokr / 2), nil, true)
                SMODS.calculate_effect(
                    { message = localize { type = 'variable', key = 'a_cracker_discards', vars = { math.floor(jokr / 2) } } }, card)
            end
        end
    end,
    b_yellow = function(self, card, context)
        if context.modify_final_cashout then
            return {
                modify = math.floor(context.amount/3),
                cashout_row = {name = 'custom', text = localize('k_cracker_card_pack_yellow'), text_colour = G.C.GOLD}
            }
        end
    end,
}
Cracker.card_pack_localize = {
    b_black = function(self, info_queue, card, vars)
        return { 1, 2 }
    end,
    b_yellow = function(self, info_queue, card, vars)
        return { 3, 1 }
    end,
}

SMODS.Voucher {
    key = 'card_pack',
    pos = {
        x = 7,
        y = 0
    },
    unlocked = true,
    discovered = true,
    atlas = 'Vouchers',
    config = {
        extra = {
            back = nil
        }
    },
    loc_vars = function(self, info_queue, card)
        local vars = {}
        if not card.ability.extra.back then
            card.ability.extra.back = G.GAME.selected_back_key and G.GAME.selected_back_key.key
        end
        if card.ability.extra.back and Cracker.card_pack_localize[card.ability.extra.back] then
            vars = Cracker.card_pack_localize[card.ability.extra.back](self, info_queue, card, vars)
        end
        return {vars = vars, key = card.ability.extra.back and Cracker.card_pack_supported[card.ability.extra.back] and 'v_cracker_card_pack_'..card.ability.extra.back or 'v_cracker_card_pack'}
    end,
    in_pool = function(self, args)
        return G.GAME.selected_back_key and Cracker.card_pack_supported[G.GAME.selected_back_key.key]
    end,
    redeem = function(self, card)
        if not card.ability.extra.back then
            card.ability.extra.back = G.GAME.selected_back_key and G.GAME.selected_back_key.key
        end
        if card.ability.extra.back and Cracker.card_pack_redeem[card.ability.extra.back] then
            Cracker.card_pack_redeem[card.ability.extra.back](self, card)
        end
    end,
    calculate = function(self, card, context)
        if card.ability.extra.back and Cracker.card_pack_calculate[card.ability.extra.back] then
            return Cracker.card_pack_calculate[card.ability.extra.back](self, card, context)
        end
    end,
}
