-- ======================================================================
-- Copyright (c) 2012 RapidFire Studio Limited 
-- Modified By Mingfei Liang 2019
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
require "a-star"
require "maphandler"

local maphandler = Maphandler.New()
local astar = astar.New()

local graph1 = maphandler:GetMap1()
local graph2 = maphandler:GetMap2()
local graph3 = maphandler:GetMap3()

local ignore = true

local path = astar:path ( graph3 [ astar:getNodeID(-2.21,9.46) ], graph3 [ astar:getNodeID(6.49,-8.51) ], graph3, ignore, valid_node_func )

if not path then
	print ( "No valid path found" )
else
	for i, node in ipairs ( path ) do
		print ( "Step " .. i .. " >> " .. node.id )
	end
end
