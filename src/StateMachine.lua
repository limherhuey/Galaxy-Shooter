--[[
	Code taken and edited from lessons in http://howtomakeanrpg.com

	States are only created as need, to save memory, reduce clean-up bugs and increase speed
	due to garbage collection taking longer with more data in memory.

	States are added with a string identifier and an intialisation function.
	It is expected that the init function, when called, will return a table with
	Render, Update, Enter and Exit methods.

	Arguments passed into the Change function after the state name
	will be forwarded to the Enter function of the state being changed too.
]]

StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}  -- [name] -> [function that returns states]
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName])
    self.current:exit()
    --set state to stateName and call its function
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end