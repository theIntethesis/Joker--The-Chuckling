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
				for _, card in ipairs(G.playing_cards) do
					card:remove_from_deck()
				end
				for i = 12, 1, -1 do
					local _card = create_playing_card({
						front = 'W_'..i,
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local _card = create_playing_card({
						front = 'U_'..i,
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local _card = create_playing_card({
						front = 'B_'..i,
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local _card = create_playing_card({
						front = 'R_'..i,
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
				for i = 12, 1, -1 do
					local _card = create_playing_card({
						front = 'G_'..i,
						center = G.P_CENTERS.c_base
					}, G.deck)
				end
			end
		}))
	end
}