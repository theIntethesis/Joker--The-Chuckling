JTC_UTIL = {}


function JTC_UTIL.draw_cards_ignore_hand_size(numToDraw)
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false
        return true    
    end
    delay(0.3)
    for i=1, numToDraw, 1 do
        draw_card(G.deck,G.hand, i*100/numToDraw, 'up', true)
    end
end

function JTC_UTIL.get_mana_table(scored_cards)
    retme = {
        white = 0,
        blue = 0, 
        black = 0,
        red = 0, 
        green = 0,
        mana_value = #scored_cards
    }
    for _, c in ipairs(scored_cards) do
        if c.is_suit("JTC_White") then retme.white = retme.white + 1 end
        if c.is_suit("JTC_Blue")  then retme.blue = retme.blue + 1 end
        if c.is_suit("JTC_Black") then retme.black = retme.black + 1 end
        if c.is_suit("JTC_Red")   then retme.red = retme.red + 1 end
        if c.is_suit("JTC_Green") then retme.green = retme.green + 1 end
    end
    return retme
end

function JTC_UTIL.destroy_playing_cards(destroyed_cards, card, effects)
    G.E_MANAGER:add_event(Event({
        func = function()
            if #destroyed_cards > 0 and type(effects) == 'table' then
                effects.sound = 'tarot1'
                effects.instant = true
                SMODS.calculate_effect(effects, card)
            end

            for _, v in ipairs(destroyed_cards) do
                if SMODS.shatters(v) then 
                    v:shatter()
                else
                    v:start_dissolve()
                end
            end

            G.E_MANAGER:add_event(Event {
                func = function()
                    SMODS.calculate_context({
                        remove_playing_cards = true,
                        removed = destroyed_cards
                    })
                    return true
                end

            })
            return true
        end
    }))
end

function JTC_UTIL.hand_has_colors(scored_cards, card, colors)
    --[[
    colors = {
        white = true,
        blue = true,
        black = true,
        red = true,
        green = true
    } ]]
    for _, c in ipairs(scored_cards) do
        if c:is_suit("JTC_White") then colors.white = true end
        if c:is_suit("JTC_Blue")  then colors.blue = true end
        if c:is_suit("JTC_Black") then colors.black = true end
        if c:is_suit("JTC_Red")   then colors.red   = true end
        if c:is_suit("JTC_Green") then colors.green = true end
    end
    return colors.white and colors.blue and colors.black and colors.red and colors.green
end

function JTC_UTIL.get_xchips(scoring_hand, mult_value)
	all_chips = G.GAME.current_round.current_hand.chips
	for _, c in ipairs(scoring_hand) do
		if not c.debuff then all_chips = all_chips + c.base.nominal end
	end
	added_chips = all_chips * (mult_value - 1)
	return added_chips
end

JTC_UTIL.Card_Types = {
    "Faction", "Spell", "Artifact"
}


function JTC_UTIL.get_number_of_artifacts()
    retme = 0
    if G.jokers and G.jokers.cards then
        for _, current_card in pairs(G.jokers.cards) do
            if type(current_card.ability.extra) == "table" and current_card.ability.extra.artifact then retme = retme + current_card.ability.extra.artifact end
        end
    end
    if G.consumeables and G.consumeables.cards then 
        for _, current_card in pairs(G.consumeables.cards) do
            if type(current_card.ability.extra) == "table" and current_card.ability.extra.artifact then retme = retme + current_card.ability.extra.artifact end
        end
    end
    sendDebugMessage("Number of Artifacts: "..retme, "MyDebugLogger")
    return retme
end

function JTC_UTIL.debug(string)
    sendDebugMessage(string, "MyDebugLogger")
end

function JTC_UTIL.destroy_joker(card, after)
    G.E_MANAGER:add_event(Event({
      func = function()
        play_sound('tarot1')
        card.T.r = -0.2
        card:juice_up(0.3, 0.4)
        card.states.drag.is = true
        card.children.center.pinch.x = true
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.3,
          blockable = false,
          func = function()
            G.jokers:remove_card(card)
            card:remove()
  
            if after and type(after) == "function" then
              after()
            end
  
            return true
          end
        }))
        return true
      end
    }))
  end
  