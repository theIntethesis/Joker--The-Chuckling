SMODS.Back {
	name = "Leyline Deck",
	key = 'leyline',
	loc_txt = {
		name = "Leyline Deck",
		text = {
			"Start run with",
			"12 cards each of",
			"White, Blue, Black, Red,",
			"and Green suit"
		}
	},
	atlas = 'LeylineBack',
	pos = {x=0,y=0},
	config = {

	},
	apply = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				for i = #G.playing_cards, 1, -1 do
					local card  = G.playing_cards[i]
					card:start_dissolve(nil, i == #G.playing_cards)
				end
				for i = 12, 1, -1 do
					local r = ""
					if i == 1 then
						r = "Ace"
					elseif i == 11 then
						r = "Jack"
					elseif i == 12 then
						r = "Queen"
					else
						r = ''..i
					end
					local _card = create_playing_card({
						front = {
							name = 'JTC_W_'..r,
							suit = JTC.WhiteMana,
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local r = ""
					if i == 1 then
						r = "Ace"
					elseif i == 11 then
						r = "Jack"
					elseif i == 12 then
						r = "Queen"
					else
						r = ''..i
					end
					local _card = create_playing_card({
						front = {
							name = 'JTC_U_'..r,
							suit = JTC.BlueMana,
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local r = ""
					if i == 1 then
						r = "Ace"
					elseif i == 11 then
						r = "Jack"
					elseif i == 12 then
						r = "Queen"
					else
						r = ''..i
					end
					local _card = create_playing_card({
						front = {
							name = 'JTC_B_'..r,
							suit = JTC.BlackMana,
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local r = ""
					if i == 1 then
						r = "Ace"
					elseif i == 11 then
						r = "Jack"
					elseif i == 12 then
						r = "Queen"
					else
						r = ''..i
					end
					local _card = create_playing_card({
						front = {
							name = 'JTC_R_'..r,
							suit = JTC.RedMana,
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local r = ""
					if i == 1 then
						r = "Ace"
					elseif i == 11 then
						r = "Jack"
					elseif i == 12 then
						r = "Queen"
					else
						r = ''..i
					end
					local _card = create_playing_card({
						front = {
							name = 'JTC_G_'..r,
							suit = JTC.GreenMana,
							value = r,
							nominal = i
						},
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				return true
			end
		}))
	end
}