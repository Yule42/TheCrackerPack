-- dx + pit blinds
SMODS.Atlas {
    key = 'dxpitblinds',
    path = "dxpitblinds.png",
    px = 34,
    py = 34,
    frames = 21, 
    atlas_table = 'ANIMATION_ATLAS'
}

if not Cracker.All_in_Jest_conf or not Cracker.All_in_Jest_conf.aij_lite then
    SMODS.Blind {
        key = 'aij_the_heart_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true
        },
        in_pool = function(self)
          return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante >= 4)
        end,
        mult = 2,
        dependencies = "allinjest",
        boss_colour = HEX("664a4a"),
        atlas = 'dxpitblinds',
        pos = { y = 0 },
        order = 501,
        dollars = 6,
        config = {extra = {trigger = false,  hand = "[hand]"}},

        loc_vars = function(self)
            return {
                vars = {
                    G.GAME.current_round.aij_the_heart_dx and G.GAME.current_round.aij_the_heart_dx.hand or "[hand]"
                }
            }
        end,

        collection_loc_vars = function(self)
            local hand_text = "[hand]"
            return {
                vars = {
                    hand_text
                }
            }
        end,

        defeat = function(self)
            self.boss.hand = "[hand]"
        end,

        debuff_hand = function(self, cards, poker_hands, text, mult, hand_chips)
            local blind_exists = G.GAME.blind and G.GAME.blind.ability
            if blind_exists then
                G.GAME.current_round.aij_the_heart_dx = {hand = G.GAME.current_round.aij_the_heart_dx and G.GAME.current_round.aij_the_heart_dx.hand or "Four of a Kind"}
                local current_hand_is_matching = next(poker_hands[G.GAME.current_round.aij_the_heart_dx.hand])
                local previous_hand_matched = G.GAME.hands[G.GAME.current_round.aij_the_heart_dx.hand].played_this_round > 0
                if current_hand_is_matching or previous_hand_matched then
                    return false
                end
            end
            G.GAME.blind.triggered = true
            return true
        end,
    }

    SMODS.current_mod.reset_game_globals = function(run_start)
        if G.GAME.round_resets.blind_states.Boss == 'Defeated' or run_start then
            reset_the_heart_dx_blind()
        end
    end

    function reset_the_heart_dx_blind()
        local hands = {
            "Full House",
            "Four of a Kind",
            "Straight Flush",
        }
        local chosen_hand = pseudorandom_element(hands, pseudoseed('jest_the_heart_dx_blind'..G.GAME.round_resets.ante))
        G.GAME.current_round.aij_the_heart_dx = {hand = chosen_hand or "Four of a Kind"}
    end

    SMODS.Blind {

        key = 'aij_the_rains_dx',
        boss = {
          min = 4,
          trigger = false,
          all_in_jest = {
              pit = true
          },
          dx = true
        },
        in_pool = function(self)
          return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante >= 4)
        end,
        mult = 2,
        boss_colour = HEX("565b67"),
        atlas = 'dxpitblinds',
        pos = { y = 1 },
        order = 502,
        dollars = 6,
        dependencies = "allinjest",

        calculate = function(self, blind, context)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end

            if context.before and G.hand.cards and not temp then
                for i = 1, #G.play.cards do
                    if G.play.cards[i].config.center ~= G.P_CENTERS.c_base or G.play.cards[i].edition ~= nil or G.play.cards[i].seal ~= nil  then
                        blind.triggered = true
                        break
                    end
                end
            end

            if context.all_in_jest and context.all_in_jest.before_after then
                local chipsthing = G.GAME.chips + context.total_chips >= G.GAME.blind.chips
                if chipsthing then
                    for i = 1, #G.play.cards do
                        if G.play.cards[i].config.center ~= G.P_CENTERS.c_base then
                            G.play.cards[i]:set_ability(G.P_CENTERS.c_base, nil, true)
                        end
                    end
                    for i = 1, #G.hand.cards do
                        if G.hand.cards[i].config.center ~= G.P_CENTERS.c_base then
                            G.hand.cards[i]:set_ability(G.P_CENTERS.c_base, nil, true)
                        end
                    end
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        func = (function() 
                            local removed_edition = false
                            blind:wiggle()
                            for i = 1, #G.play.cards do
                                G.play.cards[i]:set_seal(nil, nil, true)
                                if G.play.cards[i].edition ~= nil then
                                    removed_edition = true
                                end
                                G.play.cards[i]:set_edition(nil, true, true)
                                G.play.cards[i]:juice_up()
                            end
                            for i = 1, #G.hand.cards do
                                G.hand.cards[i]:set_seal(nil, nil, true)
                                if G.hand.cards[i].edition ~= nil then
                                    removed_edition = true
                                end
                                G.hand.cards[i]:set_edition(nil, true, true)
                                G.hand.cards[i]:juice_up()
                            end
                            if removed_edition then
                                play_sound('whoosh2', 1.2, 0.6)
                            end
                            return true
                        end)
                    }))
                    blind.triggered = false
                end
            end
        end
    }

    SMODS.Blind {
      key = 'aij_the_child_dx',
      boss = {
        min = 4,
        all_in_jest = {
          pit = true
        },
        dx = true,
      },
      in_pool = function(self)
        return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
      end,
      mult = 2,
      boss_colour = HEX("796f5b"),
      atlas = 'dxpitblinds',
      pos = { y = 2 },
      order = 503,
      dollars = 6,
      dependencies = "allinjest",

      calculate = function(self, blind, context)
        local temp = G.GAME.blind and G.GAME.blind.disabled
        if temp then
          return
        end

        if context.before and G.hand.cards and not temp then
          for i = 1, #context.scoring_hand do
            if context.scoring_hand[i].base ~= 2 then
              blind.triggered = true
              break
            end
          end
        end

        if context.after and context.scoring_hand and not temp and blind.triggered then
          G.E_MANAGER:add_event(Event({
            func = function()
              blind:wiggle()
              return true
            end
          }))
          for i = 1, #context.scoring_hand do
            local percent = 1.15 - (i - 0.999) / (#context.scoring_hand - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.15,
              func = function()
                context.scoring_hand[i]:flip()
                play_sound('card1', percent)
                context.scoring_hand[i]:juice_up(0.3, 0.3)
                return true
              end
            }))
          end
          for i = 1, #context.scoring_hand do
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.1,
              func = function()
                assert(SMODS.change_base(context.scoring_hand[i], nil, pseudorandom_element(SMODS.Ranks, pseudoseed('jest_the_child_dx'..G.GAME.round_resets.ante)).key))
                return true
              end
            }))
          end
          for i = 1, #context.scoring_hand do
            local percent = 0.85 + (i - 0.999) / (#context.scoring_hand - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.15,
              func = function()
                if context.scoring_hand[i].facing == "back" then
                  context.scoring_hand[i]:flip()
                  play_sound('tarot2', percent, 0.6)
                  context.scoring_hand[i]:juice_up(0.3, 0.3)
                end
                return true
              end
            }))
          end
          delay(0.5)
          blind.triggered = false
        end
      end
    }

    SMODS.Blind {
        key = 'aij_the_moon_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true,
        },
        in_pool = function(self)
            return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
        end,
        mult = 2,
        boss_colour = HEX("796f5b"),
        atlas = 'dxpitblinds',
        pos = { y = 3 },
        order = 504,
        dollars = 6,
        dependencies = "allinjest",

        calculate = function(self, blind, context)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end
            if context.setting_blind and not temp then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = (function()
                        local debuff = false
                        for k, v in pairs(G.playing_cards) do
                            if context.setting_blind then
                                if debuff then
                                    SMODS.debuff_card(v, true, 'the_moon_dx')
                                    debuff = false
                                else
                                    debuff = true
                                end
                            end
                        end
                        return true 
                    end
                )}))
            end
        end,

        disable = function(self)
            for k, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, false, 'the_moon_dx')
            end
        end,

        defeat = function(self)
            for k, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, false, 'the_moon_dx')
            end
        end
    }
end

SMODS.Blind {
    key = 'aij_the_shell_dx',
    boss = {
      min = 4,
      odds = 4,
      odds2 = 3,
      all_in_jest = {
          pit = true
      },
      dx = true
    },
    lite = true,
    in_pool = function(self)
        return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("81687a"),
    atlas = 'dxpitblinds',
    pos = { y = 4 },
    order = 505,
    dollars = 6,
    dependencies = "allinjest",

    loc_vars = function(self)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, self.boss.odds)
        local numerator2, denominator2 = SMODS.get_probability_vars(self, 1, self.boss.odds2)

        return {
            vars = {numerator, denominator, numerator2, denominator2}
        }
    end,

    collection_loc_vars = function(self)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, self.boss.odds)
        local numerator2, denominator2 = SMODS.get_probability_vars(self, 1, self.boss.odds2)

        return {
            vars = {numerator, denominator, numerator2, denominator2}
        }
    end,

    set_blind = function(self)
        for k, v in pairs(G.playing_cards) do
            if SMODS.pseudorandom_probability(self, 'the_shell_dx', 1, G.GAME.blind.config.blind.boss.odds) then
                SMODS.debuff_card(v, true, 'the_shell_dx')
            end
        end
        for i=1, #G.deck.cards do
            if SMODS.pseudorandom_probability(self, 'the_shell_dx', 1, G.GAME.blind.config.blind.boss.odds2) then
                draw_card(G.deck, G.discard)
            end
        end
    end,

    stay_flipped = function(self, area, card)
        if area == G.hand then
            if card.debuff then
                return true
            end
        end
    end,

    disable = function(self)
        for k, v in pairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'the_shell_dx')
        end
        for k, v in pairs(G.hand.cards) do
            if v.facing == 'back' then
                v:flip()
            end
            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end
        end
    end,

    defeat = function(self)
        for k, v in pairs(G.playing_cards) do
            SMODS.debuff_card(v, false, 'the_shell_dx')
        end
        for k, v in pairs(G.hand.cards) do
            if v.facing == 'back' then
                v:flip()
            end
            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end
        end
    end,
}

if not Cracker.All_in_Jest_conf or not Cracker.All_in_Jest_conf.aij_lite then 
    SMODS.Blind {
        key = 'aij_the_earth_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true
        },
        in_pool = function(self)
            return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
        end,
        mult = 2,
        boss_colour = HEX("b5aaa4"),
        atlas = 'dxpitblinds',
        pos = { y = 5 },
        order = 506,
        dollars = 6,

        set_blind = function(self)
            for i=1, G.GAME.starting_deck_size do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        local card = SMODS.add_card({ set = 'Base', area = G.deck, enhancement = "m_stone" })
                        card.ability.aij_the_earth_dx = true
                        return true
                    end
                }))
            end
        end,
        disable = function(self)
            for _, card in pairs(G.hand.cards) do
                if card.ability.aij_the_earth_dx then
                    if SMODS.shatters(card) then -- if it's been enhanced to glass for some reason
                        card:shatter()
                    else
                        card:start_dissolve()
                    end
                end
            end
            G:update_draw_to_hand()
        end,
        defeat = function(self)
            for _, card in pairs(G.deck.cards) do
                if card.ability.aij_the_earth_dx then
                    if SMODS.shatters(card) then
                        card:shatter()
                    else
                        card:start_dissolve()
                    end
                end
            end
            for _, card in pairs(G.discard.cards) do
                if card.ability.aij_the_earth_dx then
                    if SMODS.shatters(card) then
                        card:shatter()
                    else
                        card:start_dissolve()
                    end
                end
            end
        end
    }
end

SMODS.Blind {
    key = 'aij_the_dragon_dx',
    boss = {
      min = 4,
      all_in_jest = {
          pit = true
      },
      dx = true,
    },
    lite = true,
    in_pool = function(self)
        return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
    end,
    mult = 1,
    boss_colour = HEX("476357"),
    atlas = 'dxpitblinds',
    pos = { y = 6 },
    order = 507,
    dollars = 6,
    loc_vars = function(self)
        return {
            vars = {
                G.hand and G.hand.config.card_limit*2 or "[Hand Size * 2]"
            }
        }
    end,

    collection_loc_vars = function(self)
        local hand_text = "[Hand Size * 2]"
        return {
            vars = {
                hand_text
            }
        }
    end,

    set_blind = function(self)
        local draw = G.hand.config.card_limit
        local deck_length = #G.deck.cards
        for i=math.floor(draw*2)+1, deck_length do
            draw_card(G.deck, G.discard)
        end
    end,
}

if not Cracker.All_in_Jest_conf or not Cracker.All_in_Jest_conf.aij_lite then
    SMODS.Blind {
        key = 'aij_the_mountain_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true
        },
        in_pool = function(self)
            return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
        end,
        mult = 10,
        boss_colour = HEX("696969"),
        atlas = 'dxpitblinds',
        pos = { y = 7 },
        order = 508,
        dollars = 6,

        set_blind = function(self)
            G.hand:change_size(2)
        end,

        disable = function(self)
            if G.hand.config.card_limit > 1 then
                G.hand:change_size(-2)
            end
            G.GAME.blind.chips = G.GAME.blind.chips/5
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        end,

        defeat = function(self)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end
            if not temp then
                if G.hand.config.card_limit > 1 then
                    G.hand:change_size(-2)
                end
            end
        end
    }

    SMODS.Blind { 
        key = 'aij_the_conflagration_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true,
        },
        in_pool = function(self)
            return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
        end,
        mult = 1,
        boss_colour = HEX("754c4c"),
        atlas = 'dxpitblinds',
        pos = { y = 8 },
        order = 509,
        dollars = 6,

        calculate = function(self, blind, context)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end
            if context.hand_drawn and not temp then
                for i = 1, #G.hand.cards do
                    G.hand.cards[i].ability.aij_the_conflaguration_dx = true
                end
            end
        end,
        defeat = function(self)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end
            if not temp then
                for _, card in pairs(G.deck.cards) do
                    if card.ability.aij_the_conflaguration_dx then
                        if SMODS.shatters(card) then
                            card:shatter()
                        else
                            card:start_dissolve()
                        end
                    end
                end
            end
        end
    }

    SMODS.Blind {
        key = 'aij_the_umbilical_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true
        },
        in_pool = function(self)
            return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
        end,
        mult = 2,
        boss_colour = HEX("634b6a"),
        atlas = 'dxpitblinds',
        pos = { y = 9 },
        order = 510,
        dollars = 6,

        calculate = function(self, blind, context)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end
            if context.setting_blind and not temp then
                for i = 1, 3 do
                    local hand_card = pseudorandom_element(G.deck.cards, pseudoseed('jest_the_umbilical_dx'..G.GAME.round_resets.ante))
                    if hand_card then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                hand_card.ability.aij_marked = true
                                hand_card:juice_up()
                                return true
                            end
                        })) 
                    end
                end
            end
        end,

        disable = function(self)
            for k, v in pairs(G.playing_cards) do
                if v.ability.aij_marked then
                    v.ability.aij_marked = false
                end
            end
        end,

        defeat = function(self)
            for k, v in pairs(G.playing_cards) do
                if v.ability.aij_marked then
                    v.ability.aij_marked = false
                end
            end
        end
    }


    SMODS.Blind {
        key = 'aij_the_divine_dx',
        boss = {
          min = 4,
          all_in_jest = {
              pit = true
          },
          dx = true
        },
        in_pool = function(self)
            if All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled() then
                if G.playing_cards then
                    local count = 0
                    for k, v in ipairs(G.playing_cards) do
                        if next(SMODS.get_enhancements(v)) then
                            count = count + 1
                        end
                    end
                    return count >= 4
                end
            end
        end,
        mult = 2,
        boss_colour = HEX("959595"),
        atlas = 'dxpitblinds',
        pos = { y = 10 },
        order = 511,
        dollars = 6,

        debuff_hand = function(self, cards, hand, handname, check)
            if cards then
                if G.GAME.blind.only_unenhanced then
                    for k, v in ipairs(cards) do
                        if not next(SMODS.get_enhancements(v)) then
                            return false
                        end
                    end
                else
                    for k, v in ipairs(cards) do
                        if next(SMODS.get_enhancements(v)) then
                            return false
                        end
                    end
                end
                G.GAME.blind.triggered = true
                return true
            end
        end,
        calculate = function(self, blind, context)
            local temp = G.GAME.blind and G.GAME.blind.disabled
            if temp then
                return
            end
            if context.after and not temp then
                G.GAME.blind.only_unenhanced = not G.GAME.blind.only_unenhanced
            end
        end,
    }
end

SMODS.Blind {
    key = 'aij_the_bird_dx',
    boss = {
      min = 4,
      all_in_jest = {
          pit = true
      },
      dx = true,
    },
    lite = true,
    in_pool = function(self)
        return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
    end,
    mult = 2,
    boss_colour = HEX("806d56"),
    atlas = 'dxpitblinds',
    pos = { y = 11 },
    order = 512,
    dollars = 6,

    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.setting_blind then
                if #G.jokers.cards > 0 then
                    G.jokers:unhighlight_all()
                    for i = 1, 2 do
                        joker = pseudorandom_element(G.jokers.cards, pseudoseed('jest_the_bird_dx'..G.GAME.round_resets.ante))
                        joker:flip()
                    end
                    if #G.jokers.cards > 1 then
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.2,
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        if G.CONTROLLER.dragging.target then 
                                            G.CONTROLLER.dragging.target:stop_drag()
                                            G.CONTROLLER.dragging.target.states.drag.is = false
                                            G.CONTROLLER.dragging.target = nil
                                        end
                                        G.jokers:shuffle('aajk')
                                        play_sound('cardSlide1', 0.85)
                                        return true
                                    end,
                                }))
                                delay(0.15)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.jokers:shuffle('aajk')
                                        play_sound('cardSlide1', 1.15)
                                        return true
                                    end
                                }))
                                delay(0.15)
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        G.jokers:shuffle('aajk')
                                        play_sound('cardSlide1', 1)
                                        return true
                                    end
                                }))
                                delay(0.5)
                                return true
                            end
                        }))
                    end
                end
            end
        end
    end,
}

print(Cracker)
print(Cracker.All_in_Jest_conf)

if not Cracker.All_in_Jest_conf or not Cracker.All_in_Jest_conf.aij_lite then
    SMODS.Blind {
      key = 'aij_the_arrow_dx',
      boss = {
        min = 4,
        all_in_jest = {
          pit = true
        },
        dx = true
      },
      in_pool = function(self)
        return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled()
      end,
      mult = 2,
      boss_colour = HEX("574d48"),
      atlas = 'dxpitblinds',
      pos = { y = 12 },
      order = 513,
      dollars = 6,

      calculate = function(self, blind, context)
        local temp = G.GAME.blind and G.GAME.blind.disabled
        if temp then
          return
        end
        if context.all_in_jest and context.all_in_jest.before_after and not temp then
          local bool = false
          if context.total_chips <= G.GAME.round_scores.hand.amt then
            bool = true
          end
          if bool then
            mult = mod_mult(0)
            hand_chips = mod_chips(0)
            SMODS.displayed_hand = nil
            G.E_MANAGER:add_event(Event({
              trigger = 'immediate',
              func = (function()
                blind:wiggle()
                G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  delay = 0.06 * G.SETTINGS.GAMESPEED,
                  blockable = false,
                  blocking = false,
                  func = function()
                    play_sound('tarot2', 0.76, 0.4); return true
                  end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
              end)
            }))

            play_area_status_text(localize('k_not_allowed_ex'))
            
            SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true})

            -- G.E_MANAGER:add_event(Event({
            --   trigger = 'after',
            --   delay = 0.4,
            --   func = function()
            --     update_hand_text({ delay = 0 }, { mult = 0, chips = 0, chip_total = 0, level = '', handname = "Not Allowed!" })
            --     play_sound('button', 0.9, 0.6)
            --     return true
            --   end
            -- }))
            -- G.GAME.all_in_jest.reset_score.chip_total = true
          end
        end
      end
    }
end

SMODS.Blind {
    key = 'aij_the_brilliance_dx',
    boss = {
      min = 4,
      all_in_jest = {
          pit = true
      },
      dx = true
    },
    lite = true,
    in_pool = function(self)
        return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled() 
    end,
    mult = 2,
    boss_colour = HEX("8c6d59"),
    atlas = 'dxpitblinds',
    pos = { y = 13 },
    order = 514,
    dollars = 6,
    config = {extra = {score_met = false,}},

    calculate = function(self, blind, context)
        local temp = G.GAME.blind and G.GAME.blind.disabled
        if temp then
            return
        end
        if context.all_in_jest and context.all_in_jest.before_after and not temp then
            if G.GAME.blind.ability and (context.total_chips + G.GAME.chips >= G.GAME.blind.chips) and not G.GAME.blind.ability.extra.score_met then
                blind.triggered = true
                -- G.GAME.all_in_jest.reset_score.blind_total = true
            end
        end
        if context.after and not temp then
            if blind.triggered and G.GAME.blind.ability and not G.GAME.blind.ability.extra.score_met then 
                G.E_MANAGER:add_event(Event({
                  trigger = 'ease',
                  blocking = false,
                  ref_table = G.GAME,
                  ref_value = 'chips',
                  ease_to = 0,
                  delay =  0.5,
                  func = (function(t) return math.floor(t) end)
                }))
                -- SMODS.displayed_hand = nil
                G.E_MANAGER:add_event(Event({
                  trigger = 'immediate',
                  func = (function()
                    blind:wiggle()
                    G.E_MANAGER:add_event(Event({
                      trigger = 'after',
                      delay = 0.06 * G.SETTINGS.GAMESPEED,
                      blockable = false,
                      blocking = false,
                      func = function()
                        play_sound('tarot2', 0.76, 0.4); return true
                      end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    return true
                  end)
                }))

                play_area_status_text(localize('k_again_ex'))
                -- G.E_MANAGER:add_event(Event({
                --     trigger = 'after',delay = 0.4,
                --     func = (function()  update_hand_text({delay = 0}, {mult = 0, chips = 0, chip_total = 0, level = '', handname = "Again!"});play_sound('button', 0.9, 0.6);return true end)
                -- }))
                
                G.GAME.blind.ability.extra.score_met = true
                blind.triggered = false
            end
        end
    end
}
