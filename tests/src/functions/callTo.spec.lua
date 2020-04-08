return function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local callTo = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("functions"):WaitForChild("callTo"))
	local internalsSymbol = require(ReplicatedStorage:WaitForChild("fitumi"):WaitForChild("internal"):WaitForChild("internalsSymbol"))

	local function createVarArgsTable(...)
		return { length = select("#", ...), ... }
	end

	describe("callTo", function()
		it("should return the expected set of methods", function()
			local fakedTable = {
				[internalsSymbol] = {}
			}

			local result = callTo(fakedTable)
			expect(result).to.be.ok()
			expect(result).to.be.a("table")
			expect(result["didHappen"]).to.be.a("function")
			expect(result["didNotHappen"]).to.be.a("function")
			expect(result["returns"]).to.be.a("function")
		end)

		it("should error when given an invalid input", function()
			expect(function()
				callTo(nil)
			end).to.throw()
			expect(function()
				callTo(false)
			end).to.throw()
			expect(function()
				callTo(true)
			end).to.throw()
			expect(function()
				callTo(0)
			end).to.throw()
			expect(function()
				callTo(1)
			end).to.throw()
			expect(function()
				callTo(math.huge)
			end).to.throw()
			expect(function()
				callTo("hello, world")
			end).to.throw()
			expect(function()
				callTo(function() end)
			end).to.throw()
			expect(function()
				callTo({})
			end).to.throw()
		end)

		it("should report that a call happened correctly", function()
			local fakedTable = {
				[internalsSymbol] = {
					callHistory = {
						createVarArgsTable(true, 2, "three")
					}
				}
			}

			expect(callTo(fakedTable):didHappen()).to.equal(false)
			expect(callTo(fakedTable, true):didHappen()).to.equal(false)
			expect(callTo(fakedTable, true, 2):didHappen()).to.equal(false)
			expect(callTo(fakedTable, true, 2, "three"):didHappen()).to.equal(true)
		end)

		it("should report that a call did not happen correctly", function()
			local fakedTable = {
				[internalsSymbol] = {
					callHistory = {
						createVarArgsTable(true, 2, "three")
					}
				}
			}

			expect(callTo(fakedTable):didNotHappen()).to.equal(true)
			expect(callTo(fakedTable, true):didNotHappen()).to.equal(true)
			expect(callTo(fakedTable, true, 2):didNotHappen()).to.equal(true)
			expect(callTo(fakedTable, true, 2, "three"):didNotHappen()).to.equal(false)
		end)

		it("should set single return values as expected", function()
			local functionReturns = {}
			local returnValue = {}
			local fakedTable = {
				[internalsSymbol] = {
					functionReturns = functionReturns
				}
			}

			callTo(fakedTable, true, 2, "three"):returns(returnValue)

			expect(fakedTable[internalsSymbol].functionReturns).to.equal(functionReturns)
			expect(#functionReturns).to.equal(1)
			expect(functionReturns[1]).to.be.ok()
			expect(functionReturns[1]).to.be.a("table")
			expect(functionReturns[1].args).to.be.ok()
			expect(functionReturns[1].args).to.be.a("table")
			expect(functionReturns[1].args[1]).to.be.equal(true)
			expect(functionReturns[1].args[2]).to.be.equal(2)
			expect(functionReturns[1].args[3]).to.be.equal("three")
			expect(functionReturns[1].valueGetter).to.be.ok()
			expect(functionReturns[1].valueGetter).to.be.a("function")
			expect(functionReturns[1].valueGetter()).to.be.equal(returnValue)
		end)

		it("should set tuple return values as expected", function()
			local functionReturns = {}
			local fakedTable = {
				[internalsSymbol] = {
					functionReturns = functionReturns
				}
			}

			callTo(fakedTable):returns(true, 2, "three")

			local valuesGetterResult1, valuesGetterResult2, valuesGetterResult3 = functionReturns[1].valueGetter()
			expect(valuesGetterResult1).to.equal(true)
			expect(valuesGetterResult2).to.equal(2)
			expect(valuesGetterResult3).to.equal("three")
		end)
	end)
end
