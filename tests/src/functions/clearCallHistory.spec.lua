return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local clearCallHistory = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("clearCallHistory"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))

	local function createVarArgsTable(...)
		return { length = select("#", ...), ... }
	end

	describe("clearCallHistory", function()
		it("should not error with valid input", function()
			local fakedTable = {
				[internalsSymbol] = {}
			}

			expect(function()
				clearCallHistory(fakedTable)
			end).never.to.throw()
		end)

		it("should error when given an invalid input", function()
			expect(function()
				clearCallHistory(nil)
			end).to.throw()
			expect(function()
				clearCallHistory(false)
			end).to.throw()
			expect(function()
				clearCallHistory(true)
			end).to.throw()
			expect(function()
				clearCallHistory(0)
			end).to.throw()
			expect(function()
				clearCallHistory(1)
			end).to.throw()
			expect(function()
				clearCallHistory(math.huge)
			end).to.throw()
			expect(function()
				clearCallHistory("hello, world")
			end).to.throw()
			expect(function()
				clearCallHistory(function() end)
			end).to.throw()
			expect(function()
				clearCallHistory({})
			end).to.throw()
		end)

		it("should clear call history completely", function()
			local fakedTable = {
				[internalsSymbol] = {
					callHistory = {
						createVarArgsTable(true, 2, "three")
					}
				}
			}

			clearCallHistory(fakedTable)

			expect(fakedTable[internalsSymbol].callHistory).to.be.ok()
			expect(fakedTable[internalsSymbol].callHistory).to.be.a("table")
			expect(#fakedTable[internalsSymbol].callHistory).to.equal(0)
		end)
	end)
end
