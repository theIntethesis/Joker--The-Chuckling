JTC_UTIL = {}

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