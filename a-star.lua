-- ======================================================================
-- Copyright (c) 2012 RapidFire Studio Limited 
-- Modified By RavenTKF
-- All Rights Reserved. 
-- http://www.rapidfirestudio.com

-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ======================================================================
require "BaseClass"
astar = astar or BaseClass()

function astar:__init()
    astar.Instance = self

	self.INF = 1/0
	self.cachedPaths = nil
end

function astar:getInstance()
	if astar.Instance == nil then
		astar.New()
	end
	return astar.Instance
end
----------------------------------------------------------------
-- local functions
----------------------------------------------------------------

function astar:dist ( x1, y1, x2, y2 )
	
	return math.sqrt ( math.pow ( x2 - x1, 2 ) + math.pow ( y2 - y1, 2 ) )
end

function astar:dist_between ( nodeA, nodeB )

	return self:dist ( nodeA.x, nodeA.y, nodeB.x, nodeB.y )
end

function astar:heuristic_cost_estimate ( nodeA, nodeB )

	return self:dist ( nodeA.x, nodeA.y, nodeB.x, nodeB.y )
end

function astar:is_valid_node ( node, neighbor )

	local MAX_DIST = 1.2
		
	if 	neighbor.player_id == node.player_id and 
		self:dist ( node.x, node.y, neighbor.x, neighbor.y ) < MAX_DIST then
		return true
	end
	return false
end

function astar:lowest_f_score ( set, f_score )

	local lowest, bestNode = self.INF, nil
	for _, node in ipairs ( set ) do
		local score = f_score [ node ]
		if score < lowest then
			lowest, bestNode = score, node
		end
	end
	return bestNode
end

function astar:neighbor_nodes ( theNode, nodes )

	local neighbors = {}
	for _, node in ipairs ( nodes ) do
		if theNode ~= node and self:is_valid_node ( theNode, node ) then
			table.insert ( neighbors, node )
		end
	end
	return neighbors
end

function astar:not_in ( set, theNode )

	for _, node in ipairs ( set ) do
		if node == theNode then return false end
	end
	return true
end

function astar:remove_node ( set, theNode )

	for i, node in ipairs ( set ) do
		if node == theNode then 
			set [ i ] = set [ #set ]
			set [ #set ] = nil
			break
		end
	end	
end

function astar:unwind_path ( flat_path, map, current_node )

	if map [ current_node ] then
		table.insert ( flat_path, 1, map [ current_node ] ) 
		return self:unwind_path ( flat_path, map, map [ current_node ] )
	else
		return flat_path
	end
end

----------------------------------------------------------------
-- pathfinding functions
----------------------------------------------------------------

function astar:a_star ( start, goal, nodes )

	local closedset = {}
	local openset = { start }
	local came_from = {}

	local g_score, f_score = {}, {}
	g_score [ start ] = 0
	f_score [ start ] = g_score [ start ] + self:heuristic_cost_estimate ( start, goal )

	while #openset > 0 do
	
		local current = self:lowest_f_score ( openset, f_score )
		if current == goal then
			local path = self:unwind_path ({}, came_from, goal )
			table.insert ( path, goal )
			return path
		end

		self:remove_node ( openset, current )		
		table.insert ( closedset, current )
		
		local neighbors = self:neighbor_nodes ( current, nodes )
		for _, neighbor in ipairs ( neighbors ) do 
			if self:not_in ( closedset, neighbor ) then
			
				local tentative_g_score = g_score [ current ] + self:dist_between ( current, neighbor )
				 
				if self:not_in ( openset, neighbor ) or tentative_g_score < g_score [ neighbor ] then 
					came_from 	[ neighbor ] = current
					g_score 	[ neighbor ] = tentative_g_score
					f_score 	[ neighbor ] = g_score [ neighbor ] + self:heuristic_cost_estimate ( neighbor, goal )
					if self:not_in ( openset, neighbor ) then
						table.insert ( openset, neighbor )
					end
				end
			end
		end
	end
	return nil -- no valid path
end

----------------------------------------------------------------
-- exposed functions
----------------------------------------------------------------

function astar:clear_cached_paths ()

	self.cachedPaths = nil
end

function astar:path ( start, goal, nodes, ignore_cache )

	if not self.cachedPaths then self.cachedPaths = {} end
	if not self.cachedPaths [ start ] then
		self.cachedPaths [ start ] = {}
	elseif self.cachedPaths [ start ] [ goal ] and not ignore_cache then
		return self.cachedPaths [ start ] [ goal ]
	end

      local resPath = self:a_star ( start, goal, nodes )
      if not self.cachedPaths [ start ] [ goal ] and not ignore_cache then
              self.cachedPaths [ start ] [ goal ] = resPath
      end

	return resPath
end

function astar:getNodeID ( x, y )
	local x_n = math.ceil((x+10)/1)
	if x_n == 0 then
		x_n = x_n +1
	end

	local y_n = math.ceil(math.abs(y-10)/1)
	if y_n == 0 then
		y_n = y_n +1
	end
	return  x_n + (y_n - 1) * 20 
end
