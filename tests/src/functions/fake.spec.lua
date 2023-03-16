return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local fake = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("fake"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))
	local nilSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("nilSymbol"))

	local function createVarArgsTable(...)
		return { length = select("#", ...), ... }
	end

	describe("fake", function()
		local function expectValidFakeTable(tbl)
			expect(tbl).to.be.a("table")

			local internals = tbl[internalsSymbol]
			expect(internals).to.be.ok()
			expect(internals).to.be.a("table")

			expect(internals["callResults"]).to.be.ok()
			expect(internals["callResults"]).to.be.a("table")

			expect(internals["callHistory"]).to.be.ok()
			expect(internals["callHistory"]).to.be.a("table")

			expect(internals["setValues"]).to.be.ok()
			expect(internals["setValues"]).to.be.a("table")

			expect(internals["writeHistory"]).to.be.ok()
			expect(internals["writeHistory"]).to.be.a("table")
		end

		it("should create a valid fake", function()
			local result = fake()
			expectValidFakeTable(result)
		end)

		it("should record call history", function()
			local result = fake()

			result(true, 2, "three")

			local callHistory = result[internalsSymbol].callHistory
			expect(#callHistory).to.equal(1)

			local loggedCall = callHistory[1]
			expect(loggedCall).to.be.ok()
			expect(loggedCall.length).to.equal(3)
			expect(loggedCall[1]).to.equal(true)
			expect(loggedCall[2]).to.equal(2)
			expect(loggedCall[3]).to.equal("three")
		end)

		it("should return single values correctly", function()
			local result = fake()

			local returnValue = {}
			result[internalsSymbol].callResults = {
				{
					args = createVarArgsTable(true, 2, "three"),
					returnValueGetter = function() return returnValue end,
					numberOfRemainingUses = -1
				}
			}

			expect(result()).never.to.be.ok()
			expect(result(true)).never.to.be.ok()
			expect(result(true, 2)).never.to.be.ok()
			expect(result(true, 2, "three")).to.be.ok()
			expect(result(true, 2, "three")).to.equal(returnValue)
		end)

		it("should return tuple values correctly", function()
			local result = fake()

			result[internalsSymbol].callResults = {
				{
					args = createVarArgsTable(),
					returnValueGetter = function() return true, 2, "three" end,
					numberOfRemainingUses = -1
				}
			}

			expect(result()).to.be.ok()

			local returnedVal1, returnedVal2, returnedVal3 = result()
			expect(returnedVal1).to.equal(true)
			expect(returnedVal2).to.equal(2)
			expect(returnedVal3).to.equal("three")
		end)

		it("should respect number of matches per behavior and result correctly", function()
			local result = fake()

			local invokeCount = 0

			local returnValue = {}
			result[internalsSymbol].callBehaviors = {
				{
					args = createVarArgsTable(true, 2, "three"),
					invoke = function () invokeCount = invokeCount + 1 end,
					numberOfRemainingUses = 2
				},
			}
			result[internalsSymbol].callResults = {
				{
					args = createVarArgsTable(true, 2, "three"),
					returnValueGetter = function() return returnValue end,
					numberOfRemainingUses = 3
				},
				{
					args = createVarArgsTable(true, 2, "three"),
					throw = function () error "rip" end,
					numberOfRemainingUses = -1
				},
			}

			expect(result(true, 2, "three")).to.equal(returnValue)
			expect(invokeCount).to.equal(1)
			expect(result(true, 2, "three")).to.equal(returnValue)
			expect(invokeCount).to.equal(2)

			expect(result(true, 2, "three")).to.equal(returnValue)
			expect(invokeCount).to.equal(2)

			for _ = 1, math.random(10, 20) do
				expect(function ()
					result(true, 2, "three")
				end).to.throw()
			end
		end)

		it("should set values correctly when given simple values", function()
			local result = fake()

			result.key = "value"

			expect(result[internalsSymbol].setValues["key"]).to.equal("value")
		end)

		it("should read another fake table from keys that have never been written to", function()
			local result = fake()
			expectValidFakeTable(result.key)
		end)

		it("should read values from keys correctly when given simple values", function()
			local result = fake()

			result.key = "value"

			expect(result.key).to.equal("value")
		end)

		it("should read values from keys correctly when given nil value", function()
			local result = fake()

			result.key = nil

			expect(result.key).never.to.be.ok()
		end)

		it("should record write history", function()
			local result = fake()

			result.key = "value"
			result.key = nil

			local writeHistory = result[internalsSymbol].writeHistory
			expect(writeHistory["key"]).to.be.ok()
			expect(#writeHistory["key"]).to.equal(2)

			expect(writeHistory["key"][1]).to.be.ok()
			expect(writeHistory["key"][1]).to.be.equal("value")
			expect(writeHistory["key"][2]).to.be.ok()
			expect(writeHistory["key"][2]).to.be.equal(nilSymbol)
		end)
	end)
end
