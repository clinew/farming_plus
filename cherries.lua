
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

----

minetest.register_node("farming_plus:cherry_sapling", {
	description = S("Cherry Tree Sapling"),
	drawtype = "plantlike",
	tiles = {"farming_plus_cherry_sapling.png"},
	inventory_image = "farming_plus_cherry_sapling.png",
	wield_image = "farming_plus_cherry_sapling.png",
	paramtype = "light",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
	},
	groups = {snappy = 2, dig_immediate=3, flammable=2, attached_node = 1,
		sapling = 1},
	sounds = default.node_sound_defaults(),
	on_timer = function(pos, node)
		farming_plus.generate_tree(pos, "farming_plus:cherry_tree", "farming_plus:cherry_leaves", {"default:dirt", "default:dirt_with_grass"}, "farming_plus:cherry", 5, false)
	end,
	on_construct = function(pos)
		minetest.get_node_timer(pos):start(math.random(2400,4800))
	end,
})

local cherry_tree = table.copy(minetest.registered_nodes["default:tree"])
cherry_tree.description = "Cherry Tree"
cherry_tree.drop = "default:tree"
minetest.register_node("farming_plus:cherry_tree", cherry_tree)

local cherry_leaves = table.copy(minetest.registered_nodes["default:leaves"])
cherry_leaves.description = "Cherry Leaves"
cherry_leaves.drop = {
	max_items = 1,
	items = {
		{
			items = {"farming_plus:cherry_sapling"},
			rarity = 20,
		},
		{
			items = {"default:leaves"},
		}
	}
}
minetest.register_node("farming_plus:cherry_leaves", cherry_leaves)

minetest.register_node("farming_plus:cherry", {
	description = S("Cherry"),
	tiles = {"farming_plus_cherry.png"},
	inventory_image = "farming_plus_cherry.png",
	wield_image = "farming_plus_cherry.png",
	drawtype = "plantlike",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2,leafdecay=3,leafdecay_drop=1},
	sounds = default.node_sound_defaults(),
	on_use = minetest.item_eat(2),
})

default.register_leafdecay({
	trunks = {"farming_plus:cherry_tree"},
	leaves = {"farming_plus:cherry_leaves", "farming_plus:cherry", "default:leaves"},
	radius = 2,
})

farming_plus.add_tree("cherry",
	function(minp, maxp, blockseed)
		local tmp = {x=(maxp.x-minp.x)/2+minp.x, y=(maxp.y-minp.y)/2+minp.y, z=(maxp.z-minp.z)/2+minp.z}

		-- See corresponding function in 'bananas.lua'
		local forest = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:tree"})
		if forest == nil then
			return nil
		end

		local node = minetest.find_node_near(tmp, maxp.x-minp.x, {"default:dirt_with_grass"})
		if node == nil then
			return nil
		end
		local pos = {x=node.x, y=node.y+1, z=node.z}
		farming_plus.generate_tree(pos, "farming_plus:cherry_tree", "farming_plus:cherry_leaves",  {"default:dirt", "default:dirt_with_grass"}, "farming_plus:cherry", 10, true)
		return pos
	end,
	3
)
