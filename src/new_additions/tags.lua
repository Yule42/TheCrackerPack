local function get_available_voucher_upgrades(reserved_upgrades)
    local available_upgrades = {}
    local seen_upgrades = {}
    local in_shop = {}

    if not (G and G.GAME and G.GAME.used_vouchers and G.P_CENTERS) then
        return available_upgrades
    end

    if G.shop_vouchers and G.shop_vouchers.cards then
        for _, voucher_card in ipairs(G.shop_vouchers.cards) do
            local center = voucher_card and voucher_card.config and voucher_card.config.center
            if center and center.key then
                in_shop[center.key] = true
            end
        end
    end

    for owned_voucher_key, owned in pairs(G.GAME.used_vouchers) do
        if owned then
            for center_key, center in pairs(G.P_CENTERS) do
                if center.set == 'Voucher' and type(center.requires) == 'table' and not G.GAME.used_vouchers[center_key] then
                    for _, requirement in ipairs(center.requires) do
                        if requirement == owned_voucher_key and not seen_upgrades[center_key] then
                            seen_upgrades[center_key] = true
                            if not in_shop[center_key] and not (reserved_upgrades and reserved_upgrades[center_key]) then
                                available_upgrades[#available_upgrades + 1] = center_key
                            end
                            break
                        end
                    end
                end
            end
        end
    end

    return available_upgrades
end

SMODS.Tag {
    key = 'crystal',
    config = {
        dollars_per_tarot = 2
    },
    pos = { 
        x = 0,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.dollars_per_tarot, tag.config.dollars_per_tarot * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0)}}
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.tarot or 0) * tag.config.dollars_per_tarot)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'rocket',
    config = {
        dollars_per_planet = 2
    },
    pos = { 
        x = 1,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.dollars_per_planet, tag.config.dollars_per_planet * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0)}}
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.CONTROLLER.locks[lock] = true
            tag:yep('+', G.C.MONEY, function()
                G.CONTROLLER.locks[lock] = nil
                return true
            end)
            ease_dollars((G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.planet or 0) * tag.config.dollars_per_planet)
            tag.triggered = true
            return true
        end
    end
}

SMODS.Tag {
    key = 'wheel',
    config = {
    },
    pos = { 
        x = 2,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {}}
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
            if #editionless_jokers > 0 then
                tag:yep('+', G.C.ATTENTION, function()
                    local eligible_card = pseudorandom_element(editionless_jokers, 'wheel')
                    local edition = poll_edition('wheel', nil, false, true)
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                        eligible_card:set_edition(edition, true)
                        check_for_unlock({ type = 'have_edition' })
                        return true end
                    }))
                    return true
                end)
                tag.triggered = true
            else
                tag:nope()
            end
        end
    end
}

SMODS.Tag {
    key = 'gift',
    config = {
    },
    pos = { 
        x = 3,
        y = 0
    },
    min_ante = 2,
    discovered = true,
    atlas = 'tags',
    in_pool = function(self, args)
        return #get_available_voucher_upgrades() > 0
    end,
    loc_vars = function(self, info_queue, tag)
        return {vars = {}}
    end,
    apply = function(self, tag, context)
        if context.type == 'voucher_add' then
            if not G.shop_vouchers then
                tag:nope()
                return
            end

            G.shop_vouchers.cracker_gift_reserved_upgrades = G.shop_vouchers.cracker_gift_reserved_upgrades or {}
            local reserved_upgrades = G.shop_vouchers.cracker_gift_reserved_upgrades

            if #get_available_voucher_upgrades(reserved_upgrades) > 0 then
                tag:yep('+', G.C.SECONDARY_SET.Voucher, function()
                    local live_available_upgrades = get_available_voucher_upgrades(reserved_upgrades)
                    if #live_available_upgrades == 0 then
                        return true
                    end

                    local chosen_key = pseudorandom_element(live_available_upgrades, pseudoseed('cracker_gift_tag' .. tostring(tag.ID)))
                    reserved_upgrades[chosen_key] = true

                    local voucher = SMODS.add_voucher_to_shop(chosen_key)
                    voucher.from_tag = true
                    voucher.couponed = true
                    voucher:set_cost()
                    return true
                end)
                tag.triggered = true
            else
                tag:nope()
            end
        end
    end
}

SMODS.Tag {
    key = 'loan',
    config = {
        money = 30
    },
    pos = { 
        x = 4,
        y = 0
    },
    min_ante = 1,
    discovered = true,
    atlas = 'tags',
    loc_vars = function(self, info_queue, tag)
        return {vars = {tag.config.money}}
    end,
    apply = function(self, tag, context)
        if context.type == 'shop_end' then
            tag:yep('+', G.C.GOLD, function()
                if G.GAME.dollars ~= 0 then
                    ease_dollars(-G.GAME.dollars, true)
                end
                return true
            end)
            tag.triggered = true
        end
    end,
}
