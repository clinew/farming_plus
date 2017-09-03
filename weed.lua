
--  'farming_plus' farming mod for Minetest.
--  Copyright (C) 2017  PilzAdam, Wade Cline
--
--  This library is free software; you can redistribute it and/or
--  modify it under the terms of the GNU Lesser General Public
--  License as published by the Free Software Foundation; either
--  version 2.1 of the License, or (at your option) any later version.
--
--  This library is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--  Lesser General Public License for more details.
--
--  You should have received a copy of the GNU Lesser General Public
--  License along with this library; if not, write to the Free Software
--  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

-- main `S` code in init.lua
local S
S = farming_plus.S

minetest.register_node(":farming_plus:weed", {
	description = S("Weed"),
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	drawtype = "plantlike",
	tiles = {"farming_plus_weed.png"},
	inventory_image = "farming_plus_weed.png",
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.5+4/16, 0.5}
		},
	},
	groups = {snappy=3, flammable=2,plant=1},
	sounds = default.node_sound_leaves_defaults()
})

minetest.register_abm({
	nodenames = {"farming:soil_wet", "farming:soil"},
	interval = 30,
	chance = 100,
	catch_up = true,
	action = function(pos, node)
		if minetest.find_node_near(pos, 4, {"farming_plus:scarecrow", "farming_plus:scarecrow_light"}) ~= nil then
			return
		end
		pos.y = pos.y+1
		if minetest.get_node(pos).name == "air" then
			node.name = "farming_plus:weed"
			minetest.set_node(pos, node)
		end
	end
})

-- ========= FUEL =========
minetest.register_craft({
	type = "fuel",
	recipe = "farming_plus:weed",
	burntime = 1
})
