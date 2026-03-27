-- dx + pit blinds
SMODS.Atlas {
    key = 'dxpitblinds',
    path = "dxpitblinds.png",
    px = 34,
    py = 34,
    frames = 21, 
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Blind {
    object_type = "Blind",
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
    object_type = "Blind",
    key = 'aij_the_rains_dx',
    boss = {
      min = 4,
      trigger = false,
      all_in_jest = {
          pit = true
      }
    },
    in_pool = function(self)
      return All_in_Jest.pit_blinds_in_play() and Cracker.dx_blinds_enabled() and (G.GAME.round_resets.ante >= 4)
    end,
    mult = 2,
    boss_colour = HEX("869ca7"),
    atlas = 'dxpitblinds',
    pos = { y = 1 },
    order = 502,
    dollars = 6,

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
  object_type = "Blind",
  key = 'aij_the_child_dx',
  boss = {
    min = 4,
    all_in_jest = {
      pit = true
    }
  },
  in_pool = function(self)
    return All_in_Jest.pit_blinds_in_play()
  end,
  mult = 2,
  boss_colour = HEX("c1b297"),
  atlas = 'dxpitblinds',
  pos = { y = 2 },
  order = 503,
  dollars = 6,

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
