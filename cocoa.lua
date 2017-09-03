
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

minetest.register_node("farming_plus:cocoa_sapling", {
	description = S("Cocoa Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"farming_plus_cocoa_sapling.png"},
	inventory_image = "farming_plus_cocoa_sapling.png",
	wield_image = "farming_plus_cocoa_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate=3, flammable=2, attached_node = 1,
		sapling = 1},
	sounds = default.node_sound_defaults(),
})

local cocoa_tree = table.copy(minetest.registered_nodes["default:tree"])
cocoa_tree.description = "Cocoa Tree"
cocoa_tree.drop = "default:tree"
minetest.register_node("farming_plus:cocoa_tree", cocoa_tree)

minetest.register_node("farming_plus:cocoa_leaves", {
	drawtype = "allfaces_optional",
	tiles = {"farming_plus_banana_leaves.png"},
	paramtype = "light",
	groups = {snappy=3, leafdecay=3, flammable=2, not_in_creative_inventory=1},
 	drop = {
		max_items = 1,
		items = {
			{
				items = {'farming_plus:cocoa_sapling'},
				rarity = 20,
			},
		}
	},
	sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("farming_plus:cocoa", {
	description = S("Cocoa"),
	tiles = {"farming_plus_cocoa.png"},
	visual_scale = 0.5,
	inventory_image = "farming_plus_cocoa.png",
	wield_image = "farming_plus_cocoa.png",
	drawtype = "torchlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_abm({
	nodenames = {"farming_plus:cocoa_sapling"},
	interval = 60,
	chance = 20,
	catch_up = true,
	action = function(pos, node)
		if minetest.get_node_light(pos) < 13 then
			return
		end
		minetest.log("action", "A cocoa sapling grows into a tree at "..
			minetest.pos_to_string(pos))
		farming_plus.generate_tree(pos, "farming_plus:cocoa_tree", "farming_plus:cocoa_leaves", {"default:dirt", "default:dirt_with_grass"}, "farming_plus:cocoa", 20)
	end
})

default.register_leafdecay({
	trunks = {"farming_plus:cocoa_tree"},
	leaves = {"farming_plus:cocoa_leaves", "farming_plus:cocoa"},
	radius = 2,
})

minetest.register_craftitem("farming_plus:cocoa_bean", {
	description = "Cocoa Bean",
	inventory_image = "farming_plus_cocoa_bean.png",
})

minetest.register_craft({
	output = "farming_plus:cocoa_bean 10",
	type = "shapeless",
	recipe = {"farming_plus:cocoa"},
})

farming_plus.add_tree("cocoa",
	function(minp, maxp, blockseed)
		local tmp = {x=(maxp.x-minp.x)/2+minp.x, y=(maxp.y-minp.y)/2+minp.y, z=(maxp.z-minp.z)/2+minp.z}

		-- See corresponding function in 'bananas.ini'.
		local jungle = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:jungletree"})
		if jungle == nil then
			return nil
		end

		local node = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:dirt_with_grass"})
		if node == nil then
			return nil
		end
		local pos = {x=node.x, y=node.y+1, z=node.z}
		farming_plus.generate_tree(pos, "farming_plus:cocoa_tree", "farming_plus:cocoa_leaves", {"default:dirt", "default:dirt_with_grass"}, "farming_plus:cocoa", 10)
		return pos
	end,
	17
)
